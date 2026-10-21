<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Flow/tests/Get-Rung.Tests.ps1
    folder: tests
    name: get-rung-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Flow
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-FLOW-CD-RUNGSREGISTRY
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

    It 'returns every rung in climbing order' -Tag 'ADR-FLOW-CD-RUNGSREGISTRY' {
        (Get-Rung).name | Should -Be @('widget-uat', 'gadget-uat')
    }

    It 'returns the named rungs only' {
        $rung = Get-Rung -Name gadget-uat
        $rung | Should -BeOfType ([Catzc.Base.Flow.Rung])
        $rung.gate | Should -Be 'rc'
    }
}
