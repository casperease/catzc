# pwsh/Base.Drs/tests/Get-DrsCitationGraphViolations.Tests.ps1

The tests of `Get-DrsCitationGraphViolations`: a rule summary cites only its own domain or a domain its domain depends on, read as declared
and not transitively. Prose outside the rule registry is not read.

## Fixtures

A fixture tree in `$TestDrive` and a fixture registry, widget depends on gadget depends on gizmo. The codes are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
