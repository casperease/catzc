Describe 'Install-UvTool' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-ToolConfig { [pscustomobject]@{ uv_tool = 'azure-cli'; command = 'az'; version = '2.87' } } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolCommandSuffix { 'AzCli' } -ModuleName Catzc.Tooling.Core
        Mock Sync-SessionPath { } -ModuleName Catzc.Tooling.Core
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Core
        Mock Write-Message { } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Uv { } -ModuleName Catzc.Tooling.Core
    }

    It 'installs via uv tool with a version-pinned specifier when absent' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.87.0' } -ModuleName Catzc.Tooling.Core
        Install-UvTool -Tool 'az_cli'
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
            $Arguments -eq 'tool install azure-cli==2.87.*'
        }
    }

    It 'passes --prerelease=allow when the tool allows pre-releases' {
        Mock Get-ToolConfig { [pscustomobject]@{ uv_tool = 'azure-cli'; command = 'az'; version = '2.87'; uv_allow_prerelease = $true } } -ModuleName Catzc.Tooling.Core
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.87.0' } -ModuleName Catzc.Tooling.Core
        Install-UvTool -Tool 'az_cli'
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
            $Arguments -eq 'tool install azure-cli==2.87.* --prerelease=allow'
        }
    }

    It 'is idempotent — skips when already at the locked version' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.87.1' } -ModuleName Catzc.Tooling.Core
        Install-UvTool -Tool 'az_cli'
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'with -Force uninstalls the wrong version before installing' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.80.0' } -ModuleName Catzc.Tooling.Core
        Mock Get-Command { [pscustomobject]@{ Source = 'C:\uv\az' } } -ModuleName Catzc.Tooling.Core
        Install-UvTool -Tool 'az_cli' -Force
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Arguments -eq 'tool uninstall azure-cli' }
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Arguments -eq 'tool install azure-cli==2.87.*' }
    }

    It 'throws on a wrong version without -Force' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.80.0' } -ModuleName Catzc.Tooling.Core
        Mock Get-Command { [pscustomobject]@{ Source = 'C:\uv\az' } } -ModuleName Catzc.Tooling.Core
        { Install-UvTool -Tool 'az_cli' } | Should -Throw '*version mismatch*'
    }

    It 'throws when the tool declares no uv_tool' {
        Mock Get-ToolConfig { [pscustomobject]@{ uv_tool = $null; command = 'az'; version = '2.87' } } -ModuleName Catzc.Tooling.Core
        { Install-UvTool -Tool 'az_cli' } | Should -Throw '*no uv_tool*'
    }
}

Describe 'Uninstall-UvTool' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-ToolConfig { [pscustomobject]@{ uv_tool = 'azure-cli'; command = 'az'; version = '2.87' } } -ModuleName Catzc.Tooling.Core
        Mock Write-Message { } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Uv { } -ModuleName Catzc.Tooling.Core
    }

    It 'uninstalls via uv tool when present' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Uninstall-UvTool -Tool 'az_cli'
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter { $Arguments -eq 'tool uninstall azure-cli' }
    }

    It 'is idempotent — skips when not installed' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Uninstall-UvTool -Tool 'az_cli'
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'throws when the tool declares no uv_tool' {
        Mock Get-ToolConfig { [pscustomobject]@{ uv_tool = $null; command = 'az'; version = '2.87' } } -ModuleName Catzc.Tooling.Core
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        { Uninstall-UvTool -Tool 'az_cli' } | Should -Throw '*no uv_tool*'
    }
}
