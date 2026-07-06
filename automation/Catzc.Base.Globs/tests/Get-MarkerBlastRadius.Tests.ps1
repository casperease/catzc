Describe 'Get-MarkerBlastRadius' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'infra' = @{ description = 'd'; layer = 'loose-fileset'; include = @('infrastructure/**')
                        pipeline = 'ci-infra'; verify = @{ modules = @('Catzc.Azure.Templates'); level = 2 }
                    }
                    'base'  = @{ description = 'd'; layer = 'deployable-unit'; include = @('infrastructure/modules/**') }
                    'unit'  = @{ description = 'd'; layer = 'deployable-unit'; compose = @('base'); include = @('infrastructure/cfg/unit/**') }
                }
            })
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Get-ModuleGlobSet {
            [Catzc.Base.Globs.GlobSet]::new('catzc-fake', 'd', 'module', @('automation/Catzc.Fake/**'), @(), @(), @(), -1, $null)
        } -ModuleName Catzc.Base.Globs
    }

    It 'returns one row per touched set, declared first, with the verify scope and pipeline' {
        $rows = @(Get-MarkerBlastRadius -ChangedFile 'infrastructure/modules/vnet.bicep')
        $rows.Name | Should -Be @('infra', 'base', 'unit') -Because 'unit inherits the file through compose'
        ($rows | Where-Object Name -EQ 'infra').Pipeline | Should -Be 'ci-infra'
        ($rows | Where-Object Name -EQ 'infra').VerifyModules | Should -Be @('Catzc.Azure.Templates')
        ($rows | Where-Object Name -EQ 'infra').VerifyLevel | Should -Be 2
    }

    It 'includes the derived module sets in the answer' {
        $rows = @(Get-MarkerBlastRadius -ChangedFile 'automation/Catzc.Fake/Get-Thing.ps1')
        $rows.Name | Should -Be @('catzc-fake')
        $rows[0].Layer | Should -Be 'module'
    }

    It 'normalizes backslash paths and reports each set at most once' {
        $rows = @(Get-MarkerBlastRadius -ChangedFile 'infrastructure\modules\a.bicep', 'infrastructure\modules\b.bicep')
        @($rows | Where-Object Name -EQ 'base') | Should -HaveCount 1
    }

    It 'returns nothing for untouched sets' {
        @(Get-MarkerBlastRadius -ChangedFile 'docs/readme.md') | Should -HaveCount 0
    }

    It 'derives the changed files from a git ref with -Ref' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "infrastructure/cfg/unit/a.yml`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Globs -ParameterFilter { $Command -like 'git diff --name-only*' }

        $rows = @(Get-MarkerBlastRadius -Ref main)
        $rows.Name | Should -Be @('infra', 'unit')
    }
}
