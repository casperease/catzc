# pwsh/Base.Languages/types/PythonTestResult.cs

One Python test's result, as `Invoke-PythonTest` returns it from pytest's JUnit XML report: a top-level test function of a test file, with
its parametrised cases (`test_x[a]`, `test_x[b]`) folded into it, as Go folds subtests into their test. It has the shape of `GoTestResult`
(`Package`, `Name`, `Outcome`, `DurationSeconds`, `Output`, `Category`), so the harness maps both languages' results the same way. A result
type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Category

The category is derived here, the one place the rule lives: a test named `test_integrity*` reads the shipped artifacts and is `integrity`;
every other test is `logic` ([ADR-AUTO-TEST-ONECATEGORY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory)).
Construction validates every field and reports every violation in one `ArgumentException`.
