Describe 'Install-UvVenvTool' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-ToolConfig {
            if ($Tool -eq 'python') { [pscustomobject]@{ version = '3.14' } }
            else { [pscustomobject]@{ uv_venv = 'azure-cli'; command = 'az'; version = '2.87'; uv_allow_prerelease = $true } }
        } -ModuleName Catzc.Tooling.Core
        Mock Sync-SessionPath { } -ModuleName Catzc.Tooling.Core
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Core
        Mock Write-Message { } -ModuleName Catzc.Tooling.Core
        Mock Invoke-Uv { } -ModuleName Catzc.Tooling.Core
    }

    It 'creates a dedicated venv with the managed Python' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.87.0' } -ModuleName Catzc.Tooling.Core
        Install-UvVenvTool -Tool 'az_cli'
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
            $Arguments -like 'venv *az_cli* --python 3.14 --clear'
        }
    }

    It 'pip-installs the package into the venv with --prerelease threaded' {
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.87.0' } -ModuleName Catzc.Tooling.Core
        Install-UvVenvTool -Tool 'az_cli'
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 1 -ParameterFilter {
            $Arguments -like 'pip install --python *az_cli* azure-cli==2.87.*' -and $Prerelease
        }
    }

    It 'is idempotent — skips when already at the locked version' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Core
        Mock Get-ToolVersion { '2.87.1' } -ModuleName Catzc.Tooling.Core
        Install-UvVenvTool -Tool 'az_cli'
        Should -Invoke Invoke-Uv -ModuleName Catzc.Tooling.Core -Times 0
    }

    It 'throws when the tool declares no uv_venv' {
        Mock Get-ToolConfig { [pscustomobject]@{ uv_venv = $null; command = 'az'; version = '2.87' } } -ModuleName Catzc.Tooling.Core
        { Install-UvVenvTool -Tool 'az_cli' } | Should -Throw '*no uv_venv*'
    }
}

Describe 'Invoke-Uv' -Tag 'L0', 'logic' {
    It 'appends --prerelease=allow (and surfaces a message) under -Prerelease' {
        Invoke-Uv 'pip install azure-cli' -Prerelease -DryRun |
            Should -Be 'uv pip install azure-cli --prerelease=allow'
    }

    It 'leaves the command unchanged without -Prerelease' {
        Invoke-Uv 'pip install azure-cli' -DryRun | Should -Be 'uv pip install azure-cli'
    }
}
