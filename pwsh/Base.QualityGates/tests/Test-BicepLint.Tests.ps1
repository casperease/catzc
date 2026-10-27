Describe 'Test-BicepLint' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:repo = Join-Path $TestDrive 'repo'
        $script:out = Join-Path $TestDrive 'bicep-lint'
        $script:lint = @{}
        $script:lintExit = 0
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repo }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'widgets/gadget.bicep'; 'widgets/README.md'; 'widgets/sprocket.bicep' }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'bicep' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'C:\widget\bicep.exe'; Version = '0.30.0'; Required = '0.30' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            $file = [regex]::Match($Command, 'lint "([^"]+)"').Groups[1].Value
            [Catzc.Base.Execution.CliResult]::new('', ($script:lint[$file] ?? ''), $script:lintExit)
        }
    }

    It 'lints every tracked .bicep file under the path, one call each, and passes when the linter prints nothing' {
        (Test-BicepLint -Path widgets -OutputFolder $script:out -PassThru).IssueCount | Should -Be 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Command -like '*lint "widgets/gadget.bicep"' }
    }

    It 'reports a warning as a finding, so a linter warning fails the gate' {
        $script:lint['widgets/gadget.bicep'] = "$script:repo\widgets\gadget.bicep(3,7) : Warning no-unused-params: Parameter `"size`" is declared but never used."
        $result = Test-BicepLint -Path widgets -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeExactly 'widgets/gadget.bicep:3:7: Warning no-unused-params: Parameter "size" is declared but never used.'
        { Test-BicepLint -Path widgets -OutputFolder $script:out } | Should -Throw '*Test-BicepLint failed: 1 issue(s)*'
    }

    It 'throws with the remedy when the pinned Bicep CLI is missing' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'bicep' } {
            [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null; Version = $null; Required = '0.30' }
        }
        { Test-BicepLint -Path widgets -OutputFolder $script:out } | Should -Throw "*the tools.yml pin '0.30'*Run Install-Bicep*"
    }

    It 'throws when the linter fails with no diagnostic to report' {
        $script:lintExit = 1
        $script:lint['widgets/gadget.bicep'] = 'An unhandled exception occurred.'
        { Test-BicepLint -Path widgets -OutputFolder $script:out } | Should -Throw "*could not check 'widgets/gadget.bicep' (exit 1)*"
    }
}
