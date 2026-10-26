# pwsh/Base.QualityGates/tests/Test-Automation.Tests.ps1

The tests around `Test-Automation`: the source and test file conventions over the real tree, and the vendored Pester path.

## Source and test file conventions

This block runs the conventions through their quality gate `Test-SourceConventions`
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). The gate scans the tree once,
parses each source file once, and lists every offender. The block runs it at its tier and guards it against a silent no-op. It is
source-only, because it reads the per-function source files, which give the same answer in both run modes.

## Vendored Pester

This block is the real-asset test of
[ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest)
for the one internal asset of `Test-Automation`: the vendored Pester under the code root. Pester is already loaded in this worker, so the
test forces the lazy-load branch by hiding it from `Get-Module`, and it intercepts the re-import, because re-importing Pester mid-run would
unload the running harness. The run stops at the first step after the import. The test then checks the path it chose against the real
shipped module on disk. It is integrity and not source-only, so it runs in the source and the build run.
