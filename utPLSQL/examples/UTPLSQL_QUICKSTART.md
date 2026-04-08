# utPLSQL Quickstart

This is the smallest TDD-style example in the repo.

## Files

- [utplsql_simple_demo.sql](c:\Users\gaela\OracleSandBox\PLSQL-Learning\utPLSQL\examples\utplsql_simple_demo.sql)
- [run_utplsql_simple_demo.sql](c:\Users\gaela\OracleSandBox\PLSQL-Learning\utPLSQL\examples\run_utplsql_simple_demo.sql)

## What It Creates

- `demo_is_even`
- `test_demo_is_even`

## How To Use It

1. Run `utplsql_simple_demo.sql`
2. Run `run_utplsql_simple_demo.sql`
3. Change `demo_is_even`
4. Rerun the test

## Working Run Pattern

```sql
BEGIN
    ut.run(
        a_include_schema_expr => 'SYSTEM',
        a_include_object_expr => 'TEST_DEMO_IS_EVEN'
    );
END;
/
```
