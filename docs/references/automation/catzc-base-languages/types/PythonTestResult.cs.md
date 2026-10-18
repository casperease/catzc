# automation/Catzc.Base.Languages/types/PythonTestResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One Python test's result, as Invoke-PythonTest returns it from pytest's JUnit XML report: a top-level test function
of a test file, with its parametrised cases (test_x[a], test_x[b]) folded into it, as Go folds subtests into their
test. It has the shape of GoTestResult (Package, Name, Outcome, DurationSeconds, Output, Category), so the harness
maps both languages' results the same way. A result type, so its properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

The category is derived here, the one place the rule lives: a test named test_integrity* reads the shipped
artifacts and is `integrity`; every other test is `logic`
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)). Construction validates every
field and reports every violation in one ArgumentException.
```
