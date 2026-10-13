Describe 'Test-ToolRequiresElevation' -Tag 'L0', 'logic' {
    BeforeAll {
        # The production input is the typed record Get-ToolConfig returns, so the tests build one: a flag the record
        # does not map would be absent here exactly as in production.
        function New-TestToolConfig {
            param([hashtable] $Flags)
            $entry = @{ version = '1.0'; command = 'faketool'; version_command = 'faketool --version'; version_pattern = '(?<ver>.+)' }
            foreach ($key in $Flags.Keys) {
                $entry[$key] = $Flags[$key]
            }
            [Catzc.Tooling.Core.ToolConfig]::new($entry)
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
