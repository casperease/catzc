# pwsh/Base.QualityGates/tests/Test-ShellScripts.Tests.ps1

The test of `Test-ShellScripts`, a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## Logic

The L0 cases run over a fixture repository in `$TestDrive` with the index, the tool probe and ShellCheck mocked, and read the collected
issues. The report goes to `$TestDrive`. The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## Integrity

The integrity block proves that every shell script the repository holds is LF and passes the pinned ShellCheck. It is L2 because it drives
the ShellCheck CLI, and it self-skips without it
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)). It is
source-only, because it reads the repository's own files.
