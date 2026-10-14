Describe 'TimeoutsConfig' -Tag 'L0' {

    Context 'integrity (shipped timeouts.yml)' -Tag 'integrity' {
        It 'passes for the shipped timeouts.yml' {
            Get-Config -Config timeouts | Should -BeOfType [Catzc.Base.Timeouts.TimeoutsConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes for a minimal valid config' {
            $config = [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ default_seconds = 7 })
            $config.default_seconds | Should -Be 7
            $config.executables.Count | Should -Be 0
        }

        It 'resolves an executable entry, ignoring directory, extension and case' {
            $config = [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ default_seconds = 7; executables = @{ widget = 90 } })
            $config.SecondsFor('widget') | Should -Be 90
            $config.SecondsFor('C:\tools\Widget.exe') | Should -Be 90
            $config.SecondsFor('/usr/bin/widget') | Should -Be 90
        }

        It 'falls back to default_seconds for an unlisted or blank executable' {
            $config = [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ default_seconds = 7; executables = @{ widget = 90 } })
            $config.SecondsFor('gadget') | Should -Be 7
            $config.SecondsFor('') | Should -Be 7
            $config.SecondsFor($null) | Should -Be 7
        }

        It 'throws on an unknown key' {
            { [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ default_seconds = 7; nope = 1 }) } | Should -Throw '*unknown key*'
        }

        It 'throws when default_seconds is missing' {
            { [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ executables = @{} }) } | Should -Throw "*missing required key 'default_seconds'*"
        }

        It 'throws on a non-positive or non-whole limit (there is no "no limit" value)' -ForEach @(0, -1, 2.5, 'ten') {
            { [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ default_seconds = $_ }) } | Should -Throw '*invalid default_seconds*'
        }

        It 'throws on an executable key with a directory or extension' {
            { [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ default_seconds = 7; executables = @{ 'widget.exe' = 9 } }) } |
                Should -Throw "*invalid executables key 'widget.exe'*"
        }

        It 'reports every violation in one throw' {
            $err = { [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ nope = 1; executables = @{ widget = 0 } }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'nope'*"
            $err.Exception.Message | Should -BeLike "*missing required key 'default_seconds'*"
            $err.Exception.Message | Should -BeLike "*invalid executables.widget '0'*"
        }
    }
}
