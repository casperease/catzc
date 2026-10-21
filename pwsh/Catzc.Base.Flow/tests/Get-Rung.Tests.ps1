<#
---
catzc:
  immutable:
    with_body_sha: "902a218f982b"
  edges:
    code: pwsh/Catzc.Base.Flow/Get-Rung.ps1
    cites:
      - FDR-CD-RUNGSREGISTRY
---
#>

Describe 'Get-Rung' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.Flow -ParameterFilter { $Config -eq 'rungs' } {
            [Catzc.Base.Flow.RungsConfig]::new(@{ rungs = [ordered]@{
                        'widget-uat' = @{ environment = 'widget'; gate = 'none' }
                        'gadget-uat' = @{ environment = 'gadget'; gate = 'rc' }
                    }
                })
        }
    }

    It 'returns every rung in climbing order' -Tag 'FDR-CD-RUNGSREGISTRY' {
        (Get-Rung).name | Should -Be @('widget-uat', 'gadget-uat')
    }

    It 'returns the named rungs only' {
        $rung = Get-Rung -Name gadget-uat
        $rung | Should -BeOfType ([Catzc.Base.Flow.Rung])
        $rung.gate | Should -Be 'rc'
    }
}
