# pwsh/Base.Languages/types/BashTestResult.cs

One Bash test's result, as `Invoke-BashTest` returns it from the bats JUnit report: an `@test "<name>"` of a `.bats` file. It has the shape
of `GoTestResult` and `PythonTestResult` (`Package`, `Name`, `Outcome`, `DurationSeconds`, `Output`, `Category`), so the harness maps every
language's results the same way. A result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Category

The category is derived here, the one place the rule lives: a test whose name starts with `integrity:` reads the shipped artifacts and is
`integrity`; every other test is `logic`
([ADR-AUTO-TEST-ONECATEGORY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory)). Construction validates every
field and reports every violation in one `ArgumentException`.
