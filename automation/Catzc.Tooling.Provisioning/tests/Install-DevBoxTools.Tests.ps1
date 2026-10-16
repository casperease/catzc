<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/tests/Install-DevBoxTools.Tests.ps1
    folder: tests
    name: install-dev-box-tools-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-tooling-provisioning/tests/Install-DevBoxTools.Tests.ps1.md
---
#>

Describe 'Install-DevBoxTools' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-TestToolConfig {
            param([hashtable] $Keys)
            $entry = @{ version = '1.0'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)' }
            foreach ($key in $Keys.Keys) {
                $entry[$key] = $Keys[$key]
            }
            [Catzc.Base.Execution.ToolConfig]::new($entry)
        }
    }

    BeforeEach {
        Mock Uninstall-Chocolatey { } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolsStatus { @() } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolInstallOrder { @() } -ModuleName Catzc.Tooling.Provisioning
        Mock Install-Git { } -ModuleName Catzc.Tooling.Provisioning
        Mock Install-Postman { } -ModuleName Catzc.Tooling.Provisioning
    }

    It 'removes Chocolatey, reads status, and installs the additional tools' {
        Install-DevBoxTools
        Should -Invoke Uninstall-Chocolatey -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Get-ToolsStatus -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Install-Git -ModuleName Catzc.Tooling.Provisioning -Times 1
        Should -Invoke Install-Postman -ModuleName Catzc.Tooling.Provisioning -Times 1
    }

    It 'forwards -Force to the additional installers' {
        Install-DevBoxTools -Force
        Should -Invoke Install-Git -ModuleName Catzc.Tooling.Provisioning -Times 1 -ParameterFilter { $Force }
        Should -Invoke Install-Postman -ModuleName Catzc.Tooling.Provisioning -Times 1 -ParameterFilter { $Force }
    }

    It 'reports a tool that is usable but not managed, and leaves it untouched' {
        $usable = [Catzc.Tooling.Provisioning.ToolStatus]::new('beta', '2.x', '2.0', 'Usable', '/bin/beta', 'other', 'user', 'Works, but not managed')
        Mock Get-ToolsStatus { $usable } -ModuleName Catzc.Tooling.Provisioning
        Mock Write-Message { } -ModuleName Catzc.Tooling.Provisioning
        Install-DevBoxTools
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Message -like '*Skipping beta*' }
    }

    It 'asserts a platform-provided tool (winget, bash) through Test-Tool instead of installing it' {
        Mock Get-ToolInstallOrder { @('widget') } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolConfig { New-TestToolConfig @{ system_provided = $true } } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolCommandSuffix { 'Widget' } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-Tool { $true } -ModuleName Catzc.Tooling.Provisioning
        Install-DevBoxTools
        Should -Invoke Test-Tool -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly -ParameterFilter { $Tool -eq 'widget' -and $SkipVersionCheck }
        # No Install-Widget lookup/throw happened — the platform-provided branch returned first.
    }

    It 'fails fast, naming the probe report, when a platform-provided tool is absent' {
        Mock Get-ToolInstallOrder { @('widget') } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolConfig { New-TestToolConfig @{ system_provided = $true } } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-Tool { $false } -ModuleName Catzc.Tooling.Provisioning
        { Install-DevBoxTools } | Should -Throw '*widget is required but is provided by the platform*Write-ToolProbeReport*'
    }

    It 'installs git before the locked tools, so a platform-provided bash (Git Bash on Windows) is present' {
        $script:order = [System.Collections.Generic.List[string]]::new()
        Mock Install-Git { $script:order.Add('git') } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolInstallOrder { @('widget') } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolConfig { New-TestToolConfig @{ system_provided = $true } } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-Tool { $script:order.Add('widget'); $true } -ModuleName Catzc.Tooling.Provisioning
        Install-DevBoxTools
        $script:order | Should -Be @('git', 'widget')
    }

    It 'throws when a locked tool has no matching Install- function' {
        Mock Get-ToolInstallOrder { @('mystery') } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolCommandSuffix { 'Mystery' } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolConfig { New-TestToolConfig @{ command = 'mystery' } } -ModuleName Catzc.Tooling.Provisioning
        { Install-DevBoxTools } | Should -Throw '*No Install-Mystery function found*'
    }

    It 'skips an admin-only tool in a non-elevated run and reports it' {
        Mock Get-ToolInstallOrder { @('java') } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolConfig { New-TestToolConfig @{ command = 'java'; admin_only = $true } } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolCommandSuffix { 'Java' } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-IsAdministrator { $false } -ModuleName Catzc.Tooling.Provisioning
        Mock Write-Message { } -ModuleName Catzc.Tooling.Provisioning
        Install-DevBoxTools
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Message -like '*Skipping java*elevation*' }
    }

    It 'cascades the skip to a dependent whose skipped dependency is not available' {
        Mock Get-ToolInstallOrder { @('node_js', 'cspell') } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolConfig {
            @{
                node_js = New-TestToolConfig @{ command = 'node'; admin_only = $true }
                cspell  = New-TestToolConfig @{ command = 'cspell'; depends_on = 'node_js' }
            }[$Tool]
        } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-IsAdministrator { $false } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Provisioning
        Mock Write-Message { } -ModuleName Catzc.Tooling.Provisioning
        { Install-DevBoxTools } | Should -Not -Throw
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Message -like 'Skipping cspell*node_js*' }
    }

    It 'does not cascade when the skipped dependency''s command is still available' {
        Mock Get-ToolInstallOrder { @('node_js', 'cspell') } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolConfig {
            @{
                node_js = New-TestToolConfig @{ command = 'node'; admin_only = $true }
                cspell  = New-TestToolConfig @{ command = 'cspell'; depends_on = 'node_js' }
            }[$Tool]
        } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-ToolCommandSuffix { 'Cspell' } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-IsAdministrator { $false } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-Command { $true } -ModuleName Catzc.Tooling.Provisioning
        Mock Install-Cspell { } -ModuleName Catzc.Tooling.Provisioning
        Install-DevBoxTools
        Should -Invoke Install-Cspell -ModuleName Catzc.Tooling.Provisioning -Times 1
    }
}
