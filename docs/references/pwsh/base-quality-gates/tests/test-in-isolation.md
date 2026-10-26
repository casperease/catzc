# pwsh/Base.QualityGates/tests/Test-InIsolation.Tests.ps1

The real-asset test of
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest)
for the lazy Pester load of `Test-InIsolation`: the vendored Pester under the code root. Pester is already loaded in this worker, so the
test forces the lazy-load branch by hiding it from `Get-Module`, and it intercepts the re-import, because re-importing Pester mid-run would
unload the running harness. The run stops at the first step after the import. The test then checks the chosen path against the real shipped
module on disk. It is integrity and not source-only, so it runs in the source and the build run.
