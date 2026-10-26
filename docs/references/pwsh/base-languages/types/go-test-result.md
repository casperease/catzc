# pwsh/Base.Languages/types/GoTestResult.cs

One Go test's result, as `Invoke-GoTest` returns it from the `go test -json` event stream: a top-level test function of a package, with its
subtests folded into it (their output joins the parent's, and go itself fails the parent when a subtest fails). A result type, so its
properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Category

The category is derived here, the one place the rule lives: a test named `TestIntegrity*` reads the shipped artifacts and is `integrity`;
every other test is `logic` ([ADR-AUTO-TEST-ONECATEGORY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory)).
Construction validates every field and reports every violation in one `ArgumentException`.
