Describe 'Test-InIsolation' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ profiles = [ordered]@{ minimal = @('Catzc.Base.Asserts') } }
        }
        Mock Get-ModuleProfile -ModuleName Catzc.Base.QualityGates {
            @('Catzc.Base.Asserts', '.vendor', '.internal', '.compiled')
        }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        # Copy-Automation is mocked to fabricate a tests/ folder in the sandbox so there is something to run.
        Mock Copy-Automation -ModuleName Catzc.Base.QualityGates {
            [System.IO.Directory]::CreateDirectory((Join-Path $Destination 'automation/Catzc.Base.Asserts/tests')) | Out-Null
        }
    }

    It 'Process mode launches a child pwsh runner and reports success on exit 0' {
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 0 } }
        $result = Test-InIsolation -ModuleProfile minimal -PassThru
        $result.Isolation | Should -Be 'Process'
        $result.Success | Should -BeTrue
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'pwsh -NoProfile -File'
        }
    }

    It 'reports failure when the child exits non-zero' {
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 3 } }
        $result = Test-InIsolation -ModuleProfile minimal -PassThru
        $result.Success | Should -BeFalse
        $result.Failed | Should -Be 3
    }

    It 'the generated runner uses the optimized initializer and excludes integrity (Category Logic default)' {
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 0 } }
        $dest = Join-Path $TestDrive ([guid]::NewGuid())
        Test-InIsolation -ModuleProfile minimal -Destination $dest -KeepSandbox | Out-Null
        $runner = Get-Content (Join-Path $dest '.isolation-run.ps1') -Raw
        $runner | Should -Match 'importer\.ps1'
        $runner | Should -Match '-SkipJanitors'
        $runner | Should -Match "'integrity'"
    }

    It 'InProcess mode runs Pester in-session and restores $env:RepositoryRoot' {
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 0 } }
        Mock Invoke-Pester -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ TotalCount = 5; FailedCount = 0 }
        }
        $before = $env:RepositoryRoot
        $result = Test-InIsolation -ModuleProfile minimal -Isolation InProcess -PassThru
        $result.Isolation | Should -Be 'InProcess'
        $result.Total | Should -Be 5
        $result.Success | Should -BeTrue
        $env:RepositoryRoot | Should -Be $before
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'throws on an unknown profile name (ValidateScript)' {
        { Test-InIsolation -ModuleProfile nope } | Should -Throw
    }
}
