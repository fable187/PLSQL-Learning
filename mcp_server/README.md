# PLSQL Learning FastMCP Server

This folder contains a small local MCP server for the Oracle database used by this project.

## What It Does

The server exposes a few practical MCP tools:

- `ping_database`
- `list_schema_objects`
- `describe_table`
- `run_select`
- `execute_plsql`
- `list_sql_files`
- `read_project_file`

It also exposes a couple of resources:

- `oracle://connection-config`
- `project://sql-files`

## Setup

1. Create a local env file:

```powershell
Copy-Item mcp_server/.env.example mcp_server/.env
```

2. Install dependencies:

```powershell
python -m pip install -e ./mcp_server
```

3. Make sure your Oracle container is running.

## ChatGPT Custom MCP Setup

Use `STDIO` in the custom MCP dialog.

Command:

```text
python
```

Arguments:

```text
-m
mcp_server.server
```

If ChatGPT asks for environment variables, either:

- leave them empty and rely on `mcp_server/.env`, or
- define `ORACLE_USER`, `ORACLE_PASSWORD`, `ORACLE_HOST`, `ORACLE_PORT`, and `ORACLE_SERVICE_NAME` there instead

## Optional HTTP Mode

You can also run it as a local HTTP MCP server:

```powershell
python -m mcp_server.server --transport http --host 127.0.0.1 --port 8000
```

The MCP endpoint will be:

```text
http://127.0.0.1:8000/mcp/
```

## Notes

- `run_select` only allows a single `SELECT` or `WITH` query.
- `execute_plsql` only allows anonymous PL/SQL blocks that start with `BEGIN` or `DECLARE`.
- The first version is intentionally conservative so it is easy to trust and extend.
