import argparse
import json
import os
from dataclasses import dataclass
from datetime import date, datetime
from decimal import Decimal
from pathlib import Path
from typing import Any, Optional

import oracledb
from fastmcp import FastMCP


SERVER_NAME = "PLSQL Learning Oracle MCP"
PACKAGE_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = PACKAGE_DIR.parent
DEFAULT_DOTENV = PACKAGE_DIR / ".env"

mcp = FastMCP(SERVER_NAME)


@dataclass(frozen=True)
class OracleConfig:
    user: str
    password: str
    host: str
    port: int
    service_name: str
    dsn: Optional[str]


def load_dotenv(path: Path = DEFAULT_DOTENV) -> None:
    if not path.exists():
        return

    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        os.environ.setdefault(key, value)


def get_oracle_config() -> OracleConfig:
    load_dotenv()
    return OracleConfig(
        user=os.getenv("ORACLE_USER", "system"),
        password=os.getenv("ORACLE_PASSWORD", "oracle123"),
        host=os.getenv("ORACLE_HOST", "127.0.0.1"),
        port=int(os.getenv("ORACLE_PORT", "1521")),
        service_name=os.getenv("ORACLE_SERVICE_NAME", "PLSQLDB"),
        dsn=os.getenv("ORACLE_DSN"),
    )


def get_connection() -> oracledb.Connection:
    config = get_oracle_config()
    dsn = config.dsn or oracledb.makedsn(
        host=config.host,
        port=config.port,
        service_name=config.service_name,
    )
    return oracledb.connect(
        user=config.user,
        password=config.password,
        dsn=dsn,
    )


def parse_binds(binds_json: str) -> dict[str, Any]:
    if not binds_json.strip():
        return {}
    parsed = json.loads(binds_json)
    if not isinstance(parsed, dict):
        raise ValueError("binds_json must decode to a JSON object.")
    return parsed


def to_jsonable(value: Any) -> Any:
    if isinstance(value, Decimal):
        return float(value)
    if isinstance(value, (datetime, date)):
        return value.isoformat()
    if isinstance(value, oracledb.LOB):
        return value.read()
    if isinstance(value, list):
        return [to_jsonable(item) for item in value]
    if isinstance(value, tuple):
        return [to_jsonable(item) for item in value]
    if isinstance(value, dict):
        return {key: to_jsonable(val) for key, val in value.items()}
    return value


def normalize_table_name(name: str) -> str:
    return name.strip().upper()


def assert_safe_select(sql: str) -> str:
    normalized = sql.strip()
    lowered = normalized.lower()
    if not normalized:
        raise ValueError("SQL must not be empty.")
    if normalized.count(";") > 0:
        raise ValueError("Only a single SELECT statement without semicolons is allowed.")
    if not (lowered.startswith("select") or lowered.startswith("with")):
        raise ValueError("This tool only allows SELECT statements or CTEs that start with WITH.")
    return normalized


def assert_plsql_block(block: str) -> str:
    normalized = block.strip()
    lowered = normalized.lower()
    if not normalized:
        raise ValueError("PL/SQL block must not be empty.")
    if not (lowered.startswith("begin") or lowered.startswith("declare")):
        raise ValueError("Only anonymous PL/SQL blocks starting with BEGIN or DECLARE are allowed.")
    return normalized


def project_relative_path(relative_path: str) -> Path:
    candidate = (PROJECT_ROOT / relative_path).resolve()
    if PROJECT_ROOT not in candidate.parents and candidate != PROJECT_ROOT:
        raise ValueError("Path must stay inside the project workspace.")
    return candidate


@mcp.resource("oracle://connection-config")
def connection_config_resource() -> dict[str, Any]:
    """Show the Oracle connection settings this MCP server will use."""
    config = get_oracle_config()
    return {
        "user": config.user,
        "host": config.host,
        "port": config.port,
        "service_name": config.service_name,
        "dsn": config.dsn,
        "project_root": str(PROJECT_ROOT),
    }


@mcp.resource("project://sql-files")
def project_sql_files_resource() -> list[str]:
    """List SQL files available in this learning project."""
    files = sorted(
        str(path.relative_to(PROJECT_ROOT))
        for path in PROJECT_ROOT.rglob("*.sql")
        if ".git" not in path.parts
    )
    return files


@mcp.tool
def ping_database() -> dict[str, Any]:
    """Verify Oracle connectivity and return a small bit of session context."""
    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                """
                select
                    sys_context('USERENV', 'SESSION_USER') as session_user,
                    sys_context('USERENV', 'CURRENT_SCHEMA') as current_schema,
                    sys_context('USERENV', 'DB_NAME') as db_name,
                    sys_context('USERENV', 'SERVICE_NAME') as service_name
                from dual
                """
            )
            row = cursor.fetchone()
    return {
        "connected": True,
        "session_user": row[0],
        "current_schema": row[1],
        "db_name": row[2],
        "service_name": row[3],
    }


@mcp.tool
def list_schema_objects(
    owner: Optional[str] = None,
    object_type: Optional[str] = None,
    limit: int = 100,
) -> list[dict[str, Any]]:
    """List tables, views, packages, procedures, and other objects visible to the current user."""
    safe_limit = max(1, min(limit, 500))
    sql = """
        select owner, object_name, object_type, status
        from all_objects
        where (:owner is null or owner = upper(:owner))
          and (:object_type is null or object_type = upper(:object_type))
        order by owner, object_type, object_name
        fetch first :limit rows only
    """
    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                sql,
                {
                    "owner": owner,
                    "object_type": object_type,
                    "limit": safe_limit,
                },
            )
            columns = [col[0].lower() for col in cursor.description]
            rows = [
                {columns[index]: to_jsonable(value) for index, value in enumerate(row)}
                for row in cursor.fetchall()
            ]
    return rows


@mcp.tool
def describe_table(table_name: str, owner: Optional[str] = None) -> list[dict[str, Any]]:
    """Describe columns for a visible table or view."""
    sql = """
        select
            owner,
            table_name,
            column_id,
            column_name,
            data_type,
            data_length,
            data_precision,
            data_scale,
            nullable
        from all_tab_columns
        where table_name = :table_name
          and (:owner is null or owner = upper(:owner))
        order by owner, table_name, column_id
    """
    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                sql,
                {
                    "table_name": normalize_table_name(table_name),
                    "owner": owner,
                },
            )
            columns = [col[0].lower() for col in cursor.description]
            rows = [
                {columns[index]: to_jsonable(value) for index, value in enumerate(row)}
                for row in cursor.fetchall()
            ]
    return rows


@mcp.tool
def run_select(sql: str, binds_json: str = "{}", max_rows: int = 100) -> dict[str, Any]:
    """Run a single SELECT query and return rows as JSON-safe values."""
    safe_sql = assert_safe_select(sql)
    safe_max_rows = max(1, min(max_rows, 1000))
    binds = parse_binds(binds_json)

    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(safe_sql, binds)
            columns = [column[0].lower() for column in cursor.description]
            rows = []
            for row in cursor.fetchmany(safe_max_rows):
                rows.append(
                    {columns[index]: to_jsonable(value) for index, value in enumerate(row)}
                )

    return {
        "row_count": len(rows),
        "columns": columns,
        "rows": rows,
        "truncated_to": safe_max_rows,
    }


@mcp.tool
def execute_plsql(block: str, auto_commit: bool = True) -> dict[str, Any]:
    """Execute a single anonymous PL/SQL block that starts with BEGIN or DECLARE."""
    safe_block = assert_plsql_block(block)
    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(safe_block)
        if auto_commit:
            connection.commit()
    return {
        "executed": True,
        "auto_commit": auto_commit,
    }


@mcp.tool
def list_sql_files(glob_pattern: str = "*.sql") -> list[str]:
    """List SQL files in the current learning project."""
    files = sorted(
        str(path.relative_to(PROJECT_ROOT))
        for path in PROJECT_ROOT.rglob(glob_pattern)
        if path.is_file() and ".git" not in path.parts
    )
    return files


@mcp.tool
def read_project_file(relative_path: str) -> str:
    """Read a UTF-8 text file from this project, such as a SQL learning script."""
    path = project_relative_path(relative_path)
    if not path.is_file():
        raise FileNotFoundError(f"File not found: {relative_path}")
    return path.read_text(encoding="utf-8")


def build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=SERVER_NAME)
    parser.add_argument(
        "--transport",
        choices=["stdio", "http"],
        default="stdio",
        help="MCP transport to run.",
    )
    parser.add_argument(
        "--host",
        default="127.0.0.1",
        help="Host for HTTP transport.",
    )
    parser.add_argument(
        "--port",
        type=int,
        default=8000,
        help="Port for HTTP transport.",
    )
    return parser


def main() -> None:
    parser = build_arg_parser()
    args = parser.parse_args()

    if args.transport == "http":
        mcp.run(transport="http", host=args.host, port=args.port)
    else:
        mcp.run()


if __name__ == "__main__":
    main()

