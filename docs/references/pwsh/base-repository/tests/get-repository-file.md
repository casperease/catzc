# pwsh/Base.Repository/tests/Get-RepositoryFile.Tests.ps1

The L0 logic tests of `Get-RepositoryFile`, run over a `$TestDrive` root with `Get-RepositoryRoot` mocked.

## What it proves

Path normalization happens against the repository root, never `$PWD`. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
