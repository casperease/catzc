Describe 'Set-PermanentEnvironmentVariable / Get-PermanentEnvironmentVariable (real user environment)' -Tag 'L3', 'logic', 'ADR-AUTO-TEST#39' {
    BeforeAll {
        $script:name = 'CATZC_L3_WIDGET_' + [guid]::NewGuid().ToString('N')
        Mock Write-Message { } -ModuleName Catzc.Base.Environment
        # Removed means gone from the registry key — an empty value would read back as '' and pass a null-or-empty check.
        $script:isInUserEnvironment = {
            $key = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment')
            try {
                $key.GetValueNames() -contains $script:name
            }
            finally {
                $key.Dispose()
            }
        }
    }

    AfterAll {
        if ($IsWindows) {
            [System.Environment]::SetEnvironmentVariable($script:name, [NullString]::Value, 'User')
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
        & $script:isInUserEnvironment | Should -BeFalse -Because 'removing deletes the registry value, not empties it'
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
        & $script:isInUserEnvironment | Should -BeFalse
    }
}
