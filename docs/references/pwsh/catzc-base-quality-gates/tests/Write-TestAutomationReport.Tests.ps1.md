# pwsh/Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1

The test of `Write-TestAutomationReport`. The rows are the plain per-test shape that `ConvertTo-TestAutomationRowSet` produces. The test
builds them directly with `New-Row`, since the report never sees a live Pester object.
