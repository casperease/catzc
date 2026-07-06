Describe 'Test-ToolRequiresElevation' -Tag 'L0', 'logic' {
    It 'is true for an admin_only tool on every platform' {
        Test-ToolRequiresElevation ([pscustomobject]@{ command = 'java'; admin_only = $true }) | Should -BeTrue
    }

    It 'matches the platform for a linux_admin_only tool (true on Linux, false elsewhere)' {
        $config = [pscustomobject]@{ command = 'node'; linux_admin_only = $true }
        Test-ToolRequiresElevation $config | Should -Be ([bool] $IsLinux)
    }

    It 'is false for a user-space tool' {
        Test-ToolRequiresElevation ([pscustomobject]@{ command = 'uv' }) | Should -BeFalse
    }
}
