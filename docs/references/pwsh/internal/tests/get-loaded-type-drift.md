# pwsh/.internal/tests/Get-LoadedTypeDrift.Tests.ps1

The L0 tests of `Get-LoadedTypeDrift` over fixture code roots in `$TestDrive`.

## Fixture

A fixture source named for a type this process has loaded (`Catzc.Base.Objects/ConsoleText`) counts as loaded; a neutral one
(`Catzc.Widget/Gadget`) never is. Each case writes its own session record for its own fixture root and removes it after, so the real roots'
records are untouched
([ADR-PWSH-TYPES-STALETYPESGUARD](../../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-staletypesguard)).
