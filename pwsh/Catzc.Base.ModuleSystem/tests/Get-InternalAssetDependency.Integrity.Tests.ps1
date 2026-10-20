<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1
    folder: tests
    name: get-internal-asset-dependency-integrity-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Get-InternalAssetDependency.Integrity.Tests.ps1.md](docs/references/pwsh/catzc-base-modulesystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1.md)"
    cites:
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
      - ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

Describe 'Internal asset dependency coverage (real tree)' -Tag 'L1', 'integrity', 'source-only', 'ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY' {
    It 'every call site is literal and every internal asset dependency has a both-runs test citing ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
        $result = Test-InternalAssetDependency -PassThru -OutputFolder (Join-Path $TestDrive 'internal-asset-dependency')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
