# pwsh/Base.QualityGates/tests/Write-TestAutomationSkipReport.Tests.ps1

The test of `Write-TestAutomationSkipReport`. The writers' chokepoint returns early during a run (`$global:__PesterRunning`), so the test
lifts that guard in `BeforeAll`, which lets the report's information-stream output be asserted (see console-output-matters and
`Write-InformationColored`).

The rows are the plain per-test shape that `ConvertTo-TestAutomationRowSet` produces, because the report never sees a live Pester object.
The reducer pre-resolves `SkipReason` in the process that ran the test.
