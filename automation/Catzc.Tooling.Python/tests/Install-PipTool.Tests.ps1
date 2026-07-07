Describe 'Install-PipTool' -Tag 'L1', 'logic' {
    BeforeEach {
        # Neutral fixture tool (ADR-TEST:3) — a pip_package library, like PySpark but not a live identity.
        Mock Get-ToolConfig { [pscustomobject]@{ command = 'widget'; pip_package = 'widgetlib'; version = '4.1'; version_command = 'widget --version' } } -ParameterFilter { $Tool -eq 'widget' } -ModuleName Catzc.Tooling.Python
        Mock Get-ToolConfig { [pscustomobject]@{ version = '3.13' } } -ParameterFilter { $Tool -eq 'python' } -ModuleName Catzc.Tooling.Python
        Mock Get-ToolCommandSuffix { 'Widget' } -ModuleName Catzc.Tooling.Python
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Python
        Mock Invoke-Pip { } -ModuleName Catzc.Tooling.Python
        Mock Sync-SessionPath { } -ModuleName Catzc.Tooling.Python
        Mock Write-Message { } -ModuleName Catzc.Tooling.Python
        Mock Get-ToolVersion { '4.1.0' } -ModuleName Catzc.Tooling.Python
    }

    It 'installs into the pinned managed Python with --system (non-virtual)' -Tag 'ADR-UVPY#2' {
        InModuleScope Catzc.Tooling.Python { Install-PipTool -Tool 'widget' }
        Should -Invoke Invoke-Pip -ModuleName Catzc.Tooling.Python -Times 1 -ParameterFilter {
            $Arguments -eq 'install --python 3.13 --system widgetlib==4.1.*'
        }
    }

    It 'uninstalls with the pinned interpreter and --system before a -Force reinstall' -Tag 'ADR-UVPY#2' {
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Python
        Mock Get-ToolVersion { '3.9.0' } -ModuleName Catzc.Tooling.Python
        InModuleScope Catzc.Tooling.Python { Install-PipTool -Tool 'widget' -Force }
        Should -Invoke Invoke-Pip -ModuleName Catzc.Tooling.Python -Times 1 -ParameterFilter {
            $Arguments -eq 'uninstall --python 3.13 --system widgetlib'
        }
    }
}
