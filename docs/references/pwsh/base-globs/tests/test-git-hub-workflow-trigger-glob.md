# pwsh/Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1

The tests of `Test-GitHubWorkflowTriggerGlob`, a quality gate for drift detection
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## What it proves

A workflow's actual paths are compared with the globset's ordered projection, since GitHub paths are last match wins. The report goes to
`$TestDrive`.

## Fixtures

The fixtures are neutral (widget,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
