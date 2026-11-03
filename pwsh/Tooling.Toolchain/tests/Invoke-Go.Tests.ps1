Describe 'Invoke-Go' -Tag 'L0', 'logic' {
    It 'builds the command via -DryRun' {
        Invoke-Go 'version' -DryRun | Should -Be 'go version'
    }

    It 'passes the configured go variables through to the call, leaves the environment as found, and says once that go reads the netrc file' {
        Mock Assert-Tool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-Tool { [Catzc.Base.Execution.ExecutableProbe]::new('go', '/opt/widget/go/bin/go', 'probe', '1.27.2',
                '1.27', $true, 1, 0, 'Person') } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-Config -ParameterFilter { $Config -eq 'go' } {
            [Catzc.Base.Languages.GoConfig]::new([ordered]@{
                    package_source = [ordered]@{ name = 'widget'; url = 'https://goproxy.widget.example'; credential_env = 'WIDGET_TOKEN' }
                })
        } -ModuleName Catzc.Tooling.Toolchain
        Mock Get-GoEnvironment {
            [ordered]@{ GOPROXY = 'https://goproxy.widget.example'; GOPRIVATE = 'goproxy.widget.example'; GOSUMDB = 'off' }
        } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
        $script:seenProxy = @()
        Mock Invoke-Executable { $script:seenProxy += "$env:GOPROXY|$env:GOPRIVATE|$env:GOSUMDB" } -ModuleName Catzc.Tooling.Toolchain
        Invoke-Go 'mod download'
        $script:seenProxy | Should -Be @('https://goproxy.widget.example|goproxy.widget.example|off')
        Test-Path Env:GOPROXY | Should -BeFalse
        Test-Path Env:GOPRIVATE | Should -BeFalse
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Message -like '*WIDGET_TOKEN*netrc*' -or $Message -like '*netrc*WIDGET_TOKEN*' }
    }

    It 'asserts the tool, then runs the executable the check located' {
        Mock Assert-Tool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Test-Tool { [Catzc.Base.Execution.ExecutableProbe]::new('go', '/opt/widget/go/bin/go', 'probe', '1.27.2',
                '1.27', $true, 1, 0, 'Person') } -ModuleName Catzc.Tooling.Toolchain
        Mock Invoke-Executable { } -ModuleName Catzc.Tooling.Toolchain
        Invoke-Go 'env GOROOT' -PassThru
        Should -Invoke Assert-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Tool -eq 'go' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Command -eq '"/opt/widget/go/bin/go" env GOROOT' -and $PassThru
        }
    }
}
