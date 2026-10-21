<#
---
catzc:
  immutable:
    with_body_sha: "8514ffe041dc"
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
    cites:
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
---
#>

Describe 'Get-GuidScanFiles — shipped configs/guids.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'finds the registry it leaves out of the scan in the loaded module' {
        $registry = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/guids.yml' -Module Catzc.Base.QualityGates)) | ConvertFrom-Yaml -Ordered
        @($registry['guids'].Keys).Count | Should -BeGreaterThan 0
    }
}
