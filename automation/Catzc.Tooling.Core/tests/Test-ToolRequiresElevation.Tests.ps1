Describe 'Test-ToolRequiresElevation' -Tag 'L0', 'logic' {
    It 'is true for an admin_only tool on every platform' {
        Test-ToolRequiresElevation ([pscustomobject]@{ command = 'faketool'; admin_only = $true }) | Should -BeTrue
    }

    It 'matches the platform for a linux_admin_only tool (true on Linux, false elsewhere)' {
        $config = [pscustomobject]@{ command = 'faketool'; linux_admin_only = $true }
        Test-ToolRequiresElevation $config | Should -Be ([bool] $IsLinux)
    }

    It 'is false for a user-space tool' {
        Test-ToolRequiresElevation ([pscustomobject]@{ command = 'faketool' }) | Should -BeFalse
    }
}
