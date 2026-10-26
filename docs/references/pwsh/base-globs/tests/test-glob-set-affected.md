# pwsh/Base.Globs/tests/Test-GlobSetAffected.Tests.ps1

The tests of `Test-GlobSetAffected`, the in-pipeline check of whether there is anything for a unit to process.

## What it proves

The check reflects the context's diff and reports whether the named unit is touched. It fails open on any doubt
([ADR-REPO-PROTGLOB-FAILOPEN](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-failopen)) and fails fast on a mistyped
name.

## Fixtures

The fixture names are neutral (widget, gadget), not the shipped set names, so the logic test owns its inputs
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
