# pwsh/Base.Writers/tests/Write-InformationColored.Tests.ps1

The L0 logic tests of `Write-InformationColored`, the writers' information-stream chokepoint.

## Private writer

The writer is private, so the tests reach it through `InModuleScope`, not as an exported command. The chokepoint guard returns early during
a run (`$global:__PesterRunning`), so the tests lift the flag to assert the output.
