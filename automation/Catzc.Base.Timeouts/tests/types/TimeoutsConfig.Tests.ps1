Describe 'TimeoutsConfig' -Tag 'L0' {

    Context 'integrity (shipped timeouts.yml)' -Tag 'integrity' {
        It 'passes for the shipped timeouts.yml' {
            Get-Config -Config timeouts | Should -BeOfType [Catzc.Base.Timeouts.TimeoutsConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        BeforeAll {
            function script:New-TimeoutsConfig {
                param([System.Collections.IDictionary] $Data)
                [Catzc.Base.Timeouts.TimeoutsConfig]::new($Data)
            }
        }

        It 'resolves the sensible defaults for every environment and shell from an empty config' {
            $config = New-TimeoutsConfig ([ordered]@{})
            $config.SecondsFor('Devbox', 'Bash', $false) | Should -Be 10
            $config.SecondsFor('Devbox', 'Bash', $true) | Should -Be 1800
            $config.SecondsFor('Devbox', 'Pwsh', $false) | Should -Be 10
            $config.SecondsFor('Pipeline', 'Bash', $false) | Should -Be 600
            $config.SecondsFor('Pipeline', 'Bash', $true) | Should -Be 3600
            $config.SecondsFor('Pipeline', 'Pwsh', $false) | Should -Be 600
            $config.executables.Count | Should -Be 0
        }

        It 'resolves the defaults from a null config' {
            (New-TimeoutsConfig $null).SecondsFor('devbox', 'bash', $false) | Should -Be 10
        }

        It 'overrides one cell and keeps the defaults of the others' {
            $config = New-TimeoutsConfig ([ordered]@{ limits = @{ devbox = @{ bash = @{ foreground = 15 } } } })
            $config.SecondsFor('Devbox', 'Bash', $false) | Should -Be 15
            $config.SecondsFor('Devbox', 'Bash', $true) | Should -Be 1800
            $config.SecondsFor('Devbox', 'Pwsh', $false) | Should -Be 10
            $config.SecondsFor('Pipeline', 'Bash', $false) | Should -Be 600
        }

        It 'exposes the resolved limits, defaults filled in' {
            $config = New-TimeoutsConfig ([ordered]@{ limits = @{ pipeline = @{ pwsh = 900 } } })
            $config.limits.pipeline.pwsh | Should -Be 900
            $config.limits.devbox.bash.background | Should -Be 1800
        }

        It 'throws on a background limit for pwsh' {
            { (New-TimeoutsConfig ([ordered]@{})).SecondsFor('Devbox', 'Pwsh', $true) } | Should -Throw '*pwsh has no background limit*'
        }

        It 'throws on an unknown environment or shell when resolving' {
            { (New-TimeoutsConfig ([ordered]@{})).SecondsFor('laptop', 'Bash', $false) } | Should -Throw "*unknown environment 'laptop'*"
            { (New-TimeoutsConfig ([ordered]@{})).SecondsFor('Devbox', 'zsh', $false) } | Should -Throw "*unknown shell 'zsh'*"
        }

        It 'resolves an executable entry, ignoring directory, extension and case' {
            $config = New-TimeoutsConfig ([ordered]@{ executables = @{ widget = 90 } })
            $config.SecondsForExecutable('Devbox', 'widget') | Should -Be 90
            $config.SecondsForExecutable('Devbox', 'C:\tools\Widget.exe') | Should -Be 90
            $config.SecondsForExecutable('Pipeline', '/usr/bin/widget') | Should -Be 90
        }

        It "falls back to the environment's pwsh limit for an unlisted or blank executable" {
            $config = New-TimeoutsConfig ([ordered]@{ limits = @{ devbox = @{ pwsh = 7 } }; executables = @{ widget = 90 } })
            $config.SecondsForExecutable('Devbox', 'gadget') | Should -Be 7
            $config.SecondsForExecutable('Devbox', '') | Should -Be 7
            $config.SecondsForExecutable('Devbox', $null) | Should -Be 7
            $config.SecondsForExecutable('Pipeline', 'gadget') | Should -Be 600
        }

        It 'throws on an unknown key at <path>' -ForEach @(
            @{ path = 'the top level'; data = @{ nope = 1 }; expected = "*unknown key 'nope'*" }
            @{ path = 'limits'; data = @{ limits = @{ laptop = @{} } }; expected = "*unknown key 'limits.laptop'*" }
            @{ path = 'an environment'; data = @{ limits = @{ devbox = @{ zsh = 1 } } }; expected = "*unknown key 'limits.devbox.zsh'*" }
            @{ path = 'bash'; data = @{ limits = @{ devbox = @{ bash = @{ idle = 1 } } } }; expected = "*unknown key 'limits.devbox.bash.idle'*" }
        ) {
            { New-TimeoutsConfig $data } | Should -Throw $expected
        }

        It 'throws on the removed default_seconds key' {
            { New-TimeoutsConfig ([ordered]@{ default_seconds = 10 }) } | Should -Throw "*unknown key 'default_seconds'*"
        }

        It 'throws on a non-positive or non-whole limit, including a quoted number (there is no "no limit" value)' -ForEach @(0, -1, 2.5, 'ten', '10') {
            { New-TimeoutsConfig ([ordered]@{ limits = @{ devbox = @{ pwsh = $_ } } }) } | Should -Throw '*invalid limits.devbox.pwsh*'
        }

        It 'throws on a background limit below its foreground limit' {
            { New-TimeoutsConfig ([ordered]@{ limits = @{ pipeline = @{ bash = @{ foreground = 60; background = 30 } } } }) } |
                Should -Throw '*limits.pipeline.bash: background (30) is below foreground (60)*'
        }

        It 'throws on a shape that is not a map at <path>' -ForEach @(
            @{ path = 'limits'; data = @{ limits = 5 }; expected = '*invalid limits (must be a map*' }
            @{ path = 'an environment'; data = @{ limits = @{ devbox = 5 } }; expected = '*invalid limits.devbox (must be a map*' }
            @{ path = 'bash'; data = @{ limits = @{ devbox = @{ bash = 5 } } }; expected = '*invalid limits.devbox.bash (must be a map*' }
        ) {
            { New-TimeoutsConfig $data } | Should -Throw $expected
        }

        It 'throws on an executable key with a directory or extension' {
            { New-TimeoutsConfig ([ordered]@{ executables = @{ 'widget.exe' = 9 } }) } |
                Should -Throw "*invalid executables key 'widget.exe'*"
        }

        It 'reports every violation in one throw' {
            $err = { New-TimeoutsConfig ([ordered]@{ nope = 1; limits = @{ devbox = @{ pwsh = 0 } }; executables = @{ widget = 0 } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'nope'*"
            $err.Exception.Message | Should -BeLike "*invalid limits.devbox.pwsh '0'*"
            $err.Exception.Message | Should -BeLike "*invalid executables.widget '0'*"
        }
    }
}
