Describe 'Install-Python' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Tooling.Python
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'python'; version = '3.14' } } -ModuleName Catzc.Tooling.Python
        Mock Sync-SessionPath { } -ModuleName Catzc.Tooling.Python
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Python
        Mock Write-Message { } -ModuleName Catzc.Tooling.Python
        Mock Invoke-Uv { } -ModuleName Catzc.Tooling.Python
        Mock Get-ToolVersion { '3.14.0' } -ModuleName Catzc.Tooling.Python
    }

    It 'provisions python via uv --default when absent' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Python
        Install-Python
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Python -Times 1 -ParameterFilter {
            $Arguments -eq 'python install 3.14 --default --preview-features python-install-default'
        }
    }

    It 'is idempotent when already at the locked version' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Python
        Install-Python
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Python -Times 0
    }

    It 'reinstalls under -Force' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Python
        Install-Python -Force
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Python -Times 1 -ParameterFilter {
            $Arguments -eq 'python install 3.14 --default --preview-features python-install-default --reinstall'
        }
    }

    It 'refuses to run in a CI pipeline' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Tooling.Python
        { Install-Python } | Should -Throw '*workstations*'
    }
}
