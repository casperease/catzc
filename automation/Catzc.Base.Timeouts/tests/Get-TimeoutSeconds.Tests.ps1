Describe 'Get-TimeoutSeconds' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Timeouts {
            [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{
                    limits      = @{
                        devbox   = @{ bash = @{ foreground = 7; background = 70 }; pwsh = 8 }
                        pipeline = @{ bash = @{ foreground = 60; background = 600 }; pwsh = 80 }
                    }
                    executables = @{ widget = 90 }
                })
        }
        Mock Get-RunEnvironment -ModuleName Catzc.Base.Timeouts { 'Devbox' }
    }

    It "returns the environment's pwsh limit by default" {
        Get-TimeoutSeconds | Should -Be 8
    }

    It 'returns the bash foreground and background limits' {
        Get-TimeoutSeconds -Shell Bash | Should -Be 7
        Get-TimeoutSeconds -Shell Bash -Background | Should -Be 70
    }

    It 'resolves for the pipeline environment' {
        Mock Get-RunEnvironment -ModuleName Catzc.Base.Timeouts { 'Pipeline' }
        Get-TimeoutSeconds | Should -Be 80
        Get-TimeoutSeconds -Shell Bash -Background | Should -Be 600
        Get-TimeoutSeconds -Executable gadget | Should -Be 80
    }

    It "returns an executable's own limit" {
        Get-TimeoutSeconds -Executable 'C:\tools\widget.exe' | Should -Be 90
    }

    It "returns the environment's pwsh limit for an unlisted executable" {
        Get-TimeoutSeconds -Executable gadget | Should -Be 8
    }

    It 'passes -EnvironmentAssertIs to Get-RunEnvironment only when given' {
        Get-TimeoutSeconds -EnvironmentAssertIs Devbox | Should -Be 8
        Should -Invoke Get-RunEnvironment -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { $EnvironmentAssertIs -eq 'Devbox' }
        Get-TimeoutSeconds | Should -Be 8
        Should -Invoke Get-RunEnvironment -ModuleName Catzc.Base.Timeouts -Times 1 -Exactly -ParameterFilter { -not $EnvironmentAssertIs }
    }

    It 'throws on a pwsh background limit' {
        { Get-TimeoutSeconds -Shell Pwsh -Background } | Should -Throw '*pwsh has no background limit*'
    }
}
