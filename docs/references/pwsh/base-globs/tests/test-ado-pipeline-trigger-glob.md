# pwsh/Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1

The tests of `Test-AdoPipelineTriggerGlob`, a quality gate for drift detection
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## What it proves

Each pipeline's actual trigger is compared with its globset's projection as sets, since Azure DevOps path filters are order-independent. A
drifted or missing pipeline is one issue. The report goes to `$TestDrive`.
