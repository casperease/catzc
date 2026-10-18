Describe 'Resolve-CatzcBuildVersion' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config {
            # Two bundles on their own version lines (a mono repo: no bundle's version moves another's).
            [ordered]@{
                direct_install_version = '6.6.666'
                default_bundle         = 'widgets'
                bundles                = @{ widgets = @{ version = '3.4' }; gadgets = @{ version = '7.1' } }
            }
        } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Config -eq 'exporter' }
        Mock Write-Message { } -ModuleName Catzc.Base.Exporter
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "false`n" }
        } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Command -eq 'git rev-parse --is-shallow-repository' }
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "427`n" }
        } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Command -eq 'git rev-list --first-parent --count HEAD' }
    }

    Context 'on a devbox' {
        BeforeEach {
            Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.Exporter
        }

        It 'auto resolves to the placeholder and announces it in yellow, never asking git' {
            Resolve-CatzcBuildVersion | Should -Be '6.6.666'
            Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
                $Warning -and $Message -eq 'local build — version 6.6.666; real versions are assigned only by the pipeline'
            }
            Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Exporter -Times 0
        }

        It 'auto with -Silent stays quiet' {
            Resolve-CatzcBuildVersion -Silent | Should -Be '6.6.666'
            Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 0
        }

        It 'honours an explicit MAJOR.MINOR.PATCH, the placeholder included' {
            Resolve-CatzcBuildVersion -Version 1.2.3 | Should -Be '1.2.3'
            Resolve-CatzcBuildVersion -Version 6.6.666 | Should -Be '6.6.666'
            Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 0
        }

        It 'rejects a version that is not numeric MAJOR.MINOR.PATCH (<Bad>)' -ForEach @(
            @{ Bad = '1.2' }
            @{ Bad = 'v1.2.3' }
            @{ Bad = '1.2.3-preview' }
        ) {
            { Resolve-CatzcBuildVersion -Version $Bad } | Should -Throw -ExpectedMessage "*Invalid build version '$Bad'*"
        }
    }

    Context 'in a pipeline' {
        BeforeEach {
            Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Exporter
        }

        It 'auto resolves to the default bundle''s MAJOR.MINOR plus the first-parent commit count, without a notice' {
            Resolve-CatzcBuildVersion | Should -Be '3.4.427'
            Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 0
        }

        It 'follows the named bundle''s own version line' {
            Resolve-CatzcBuildVersion -Bundle gadgets | Should -Be '7.1.427'
        }

        It 'rejects a bundle exporter.yml does not declare' {
            { Resolve-CatzcBuildVersion -Bundle sprockets } | Should -Throw -ExpectedMessage "*Unknown bundle 'sprockets'*"
        }

        It 'throws on a shallow clone rather than miscounting' {
            Mock Invoke-Executable {
                [pscustomobject]@{ Output = "true`n" }
            } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Command -eq 'git rev-parse --is-shallow-repository' }
            { Resolve-CatzcBuildVersion } | Should -Throw -ExpectedMessage '*shallow clone*'
        }

        It 'throws when git does not return a count' {
            Mock Invoke-Executable {
                [pscustomobject]@{ Output = 'fatal: bad revision' }
            } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Command -eq 'git rev-list --first-parent --count HEAD' }
            { Resolve-CatzcBuildVersion } | Should -Throw -ExpectedMessage '*not a commit count*'
        }

        It 'rejects the placeholder passed explicitly' {
            { Resolve-CatzcBuildVersion -Version 6.6.666 } | Should -Throw -ExpectedMessage '*devbox placeholder*rejected in a pipeline*'
        }

        It 'honours another explicit version' {
            Resolve-CatzcBuildVersion -Version 2.0.1 | Should -Be '2.0.1'
        }
    }
}
