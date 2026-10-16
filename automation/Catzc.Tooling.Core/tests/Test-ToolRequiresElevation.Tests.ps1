<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/tests/Test-ToolRequiresElevation.Tests.ps1
    folder: tests
    name: test-tool-requires-elevation-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-tooling-core/tests/Test-ToolRequiresElevation.Tests.ps1.md
---
#>

Describe 'Test-ToolRequiresElevation' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-TestToolConfig {
            param([hashtable] $Flags)
            $entry = @{ version = '1.0'; command = 'faketool'; version_command = 'faketool --version'; version_pattern = '(?<ver>.+)' }
            foreach ($key in $Flags.Keys) {
                $entry[$key] = $Flags[$key]
            }
            [Catzc.Base.Execution.ToolConfig]::new($entry)
        }
    }

    It 'is true for an admin_only tool on every platform' {
        Test-ToolRequiresElevation (New-TestToolConfig @{ admin_only = $true }) | Should -BeTrue
    }

    It 'matches the platform for a linux_admin_only tool (true on Linux, false elsewhere)' {
        Test-ToolRequiresElevation (New-TestToolConfig @{ linux_admin_only = $true }) | Should -Be ([bool] $IsLinux)
    }

    It 'is false for a user-space tool' {
        Test-ToolRequiresElevation (New-TestToolConfig @{}) | Should -BeFalse
    }
}
