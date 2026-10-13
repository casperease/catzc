# Vertical system test (L3): the persistent-environment seam against the REAL user environment — state outside the
# repository that every process and every concurrent run on the machine shares, so it runs only in the
# working-folder slot. It is the one test that proves the registry round trip; every caller's logic is covered at
# L1 by mocking Get-/Set-PermanentEnvironmentVariable. It owns a scratch variable no tool uses, and removes it
# whatever happens.
Describe 'Set-PermanentEnvironmentVariable / Get-PermanentEnvironmentVariable (real user environment)' -Tag 'L3', 'logic' {
    BeforeAll {
        $script:name = 'CATZC_L3_WIDGET'
        Mock Write-Message { } -ModuleName Catzc.Base.Environment
    }

    AfterAll {
        if ($IsWindows) {
            [System.Environment]::SetEnvironmentVariable($script:name, $null, 'User')
        }
    }

    It 'sets, reads back, and removes a user variable' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_persistent_user_env'
            return
        }

        Set-PermanentEnvironmentVariable $script:name 'gadget'
        Get-PermanentEnvironmentVariable $script:name | Should -Be 'gadget'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Environment -Times 1 -ParameterFilter { $Message -eq "User environment: set $script:name to 'gadget'" }

        Set-PermanentEnvironmentVariable $script:name $null
        Get-PermanentEnvironmentVariable $script:name | Should -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Base.Environment -Times 1 -ParameterFilter { $Message -eq "User environment: removed $script:name" }
    }

    It 'writes and announces nothing when the scope already holds the value' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_persistent_user_env'
            return
        }

        Set-PermanentEnvironmentVariable $script:name 'gadget'
        Set-PermanentEnvironmentVariable $script:name 'gadget'
        Set-PermanentEnvironmentVariable $script:name $null
        Set-PermanentEnvironmentVariable $script:name $null
        Should -Invoke Write-Message -ModuleName Catzc.Base.Environment -Times 2 -Exactly
    }
}
