# pwsh/Base.QualityGates/tests/Write-TestAutomationHeader.Tests.ps1

The test of `Write-TestAutomationHeader`. The writers' chokepoint returns early during a run (`$global:__PesterRunning`), so the test lifts
that guard in `BeforeAll`, which lets the banner's information-stream output be asserted (see console-output-matters).
