# pwsh/Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1

The test of `New-TestRunFinalManifest`, the terminal `run.json` record. The first block runs over fixture inputs, with and without a
context, for a worker run, and with an opt-out tag.

## A snapshot run, written and read back

The second block proves the `run.json` that a reader sees for a run that collided with another
([ADR-AUTO-TEST-RUNSNEVERWAIT](../../../../drs/automation/test-automation.md#rule-adr-auto-test-runsneverwait)). It builds the terminal
manifest from a snapshot worker run, writes it with `Write-TestRunManifest`, and reads it back as JSON. That is the shape a script that
watches concurrent runs reads, with no unit between them mocked.
