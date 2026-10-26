# pwsh/Base.QualityGates/tests/Format-Types.Tests.ps1

The tests of `Format-Types`, which maintains each C# type source's file-scoped namespace from its module folder. Its `-DryRun` is the C#
part of `Test-Formatting` ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). A
fixture tree in `$TestDrive` stands in for the repository, with neutral widget and gadget names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). The formatting
integrity test in `Test-Formatting.Tests.ps1` checks the real tree.
