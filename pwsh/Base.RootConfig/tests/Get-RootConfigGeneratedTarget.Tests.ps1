Describe 'Get-RootConfigGeneratedTarget' -Tag 'L0', 'logic', 'ADR-REPO-ROOTCFG-ONECLASSPERWRITER' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'generated' -and $ListOwners } {
            [pscustomobject]@{ Module = 'Catzc.Base.Widget' }
        }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'generated' -and -not $ListOwners } {
            [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{
                    writers = [ordered]@{
                        'New-Gadget' = [ordered]@{ class = 'snapshot'; check = 'none'; outputs = @('gadget.yml') }
                    }
                })
        }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'rootconfig' } {
            [pscustomobject]@{ files = @(
                    [pscustomobject]@{ target = 'widget.psd1'; generator = $null; optIn = $true }
                    [pscustomobject]@{ target = 'gadget.yml'; generator = 'New-Gadget'; optIn = $true }
                    [pscustomobject]@{ target = 'trinket.json'; generator = 'New-Trinket'; optIn = $true }
                    [pscustomobject]@{ target = 'spare.txt'; generator = $null; optIn = $false }
                )
            }
        }
    }

    It 'answers each opted-in file by its generator, in the class of the generator''s own row or else the given class' {
        $rows = @(Get-RootConfigGeneratedTarget -Name 'Build-Sprocket' -Class 'import-critical' | ForEach-Object { "$($_.path)|$($_.generator)|$($_.class)" })
        $rows | Should -Be @(
            'widget.psd1|Build-RootConfig|import-critical'
            'gadget.yml|New-Gadget|snapshot'
            'trinket.json|New-Trinket|import-critical'
        )
    }

    It 'answers no file that is not opted in' {
        @(Get-RootConfigGeneratedTarget -Name 'Build-Sprocket' -Class 'import-critical' | Where-Object path -CEQ 'spare.txt') | Should -BeNullOrEmpty
    }
}
