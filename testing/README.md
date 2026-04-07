# PL/SQL Unit Testing

This folder contains examples of unit testing in PL/SQL using the Oracle Developer Tools extension for VS Code.

## Features

- **Play Button Integration**: Click the ▶️ button next to test procedures to run them individually
- **Test Explorer**: View all tests in a hierarchical structure
- **Annotations**: Use special comments to define test suites, setup/cleanup, and expectations
- **Assertion Framework**: Built-in error raising for test failures

## Test Annotations

- `--%suite(Suite Name)`: Defines a test suite
- `--%suitepath(Path)`: Organizes suites in folders
- `--%test(Test Description)`: Marks a procedure as a test case
- `--%beforeall`: Runs once before all tests in suite
- `--%afterall`: Runs once after all tests in suite
- `--%beforetest`: Runs before each test
- `--%aftertest`: Runs after each test
- `--%throws(error_code)`: Expects the test to raise a specific exception
- `--%disabled(reason)`: Skips a test with a reason

## Running Tests

1. **Individual Test**: Click the play button next to a test procedure name
2. **Test Suite**: Click the play button next to the package name
3. **All Tests**: Use the Test Explorer panel to run multiple tests
4. **Debug Mode**: Right-click a test and select "Debug Test" to step through code

## Test Structure

```plsql
CREATE OR REPLACE PACKAGE my_test_suite IS
    -- %suite(My Test Suite)

    -- %beforeall
    PROCEDURE global_setup;

    -- %beforetest
    PROCEDURE setup;

    -- %test(Test something)
    PROCEDURE test_something;

    -- %aftertest
    PROCEDURE cleanup;

    -- %afterall
    PROCEDURE global_cleanup;
END;
```

## Assertion Examples

```plsql
-- Simple assertion
IF actual_value != expected_value THEN
    RAISE_APPLICATION_ERROR(-20001, 'Expected ' || expected_value || ', got ' || actual_value);
END IF;

-- Exception testing
BEGIN
    risky_operation();
    RAISE_APPLICATION_ERROR(-20002, 'Expected exception was not raised');
EXCEPTION
    WHEN expected_exception THEN
        NULL; -- Test passes
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Unexpected exception: ' || SQLERRM);
END;
```

## Files

- `simple_unit_test_example.sql`: Basic test structure with setup/cleanup
- `advanced_unit_test_example.sql`: Comprehensive testing with multiple scenarios
- `unit_testing_example.sql`: Original example (can be enhanced with annotations)

## Tips

- Keep tests isolated and independent
- Use meaningful test names and descriptions
- Test both positive and negative scenarios
- Clean up test data in teardown procedures
- Use appropriate error codes (-20001 to -20999 for custom errors)