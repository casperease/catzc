# pwsh/Tooling.Environment/tests/Write-EnvironmentSet.Tests.ps1

The L0 tests of `Write-EnvironmentSet`. They mock the `Set-ProcessEnvironmentVariable` seam and assert the calls it receives: which
variables each channel sets, the collision and bare-literal rejections, and that a scoped block restores every target.

## Restoring an unset variable

A variable that was unset before the block snapshots as null or empty, and the restore sets it empty, which removes it. The test therefore
asserts a seam call with an empty value for that name.
