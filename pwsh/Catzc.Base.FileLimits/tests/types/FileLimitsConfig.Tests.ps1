# The type is the only place a file-limits default lives, and its bounds are asserted on construction so a wrong number never reaches a gate.
Describe 'FileLimitsConfig' -Tag 'L0', 'logic' {
    It 'takes the declared defaults for every omitted key' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{})
        $config.length_min | Should -Be 100
        $config.length_max | Should -Be 500
        $config.width_min | Should -Be 80
        $config.width_max | Should -Be 200
        $config.defaults['code'].length | Should -Be 400
        $config.defaults['code'].width | Should -Be 120
        $config.defaults['config'].length | Should -Be 300
        $config.defaults['prose'].width | Should -Be 140
        $config.languages.Count | Should -Be 0
    }

    It 'takes the defaults from a missing file as well' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        ([Catzc.Base.FileLimits.FileLimitsConfig]::new($null)).defaults['code'].length | Should -Be 400
    }

    It 'keeps the shipped value of a class key it is not given' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ defaults = @{ code = @{ width = 100 } } })
        $config.defaults['code'].width | Should -Be 100
        $config.defaults['code'].length | Should -Be 400
    }

    It 'keeps a language override as given, leaving its other limit unset' {
        $config = [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ languages = @{ widget = @{ width = 150 } } })
        $config.languages['widget'].width | Should -Be 150
        $config.languages['widget'].length | Should -BeNullOrEmpty
    }

    It 'rejects an unknown key at every level, naming the allowed set' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ gadget = 1 }) } | Should -Throw '*unknown key ''gadget''*bounds, defaults, languages*'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ defaults = @{ gadget = @{} } }) } | Should -Throw '*code, config, prose*'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ languages = @{ widget = @{ depth = 1 } } }) } | Should -Throw '*length, width*'
    }

    It 'rejects a value that is not a positive whole number' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ defaults = @{ code = @{ length = 'long' } } }) } | Should -Throw '*positive whole number*'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ languages = @{ widget = @{ width = 0 } } }) } | Should -Throw '*positive whole number*'
    }

    It 'rejects a default or override outside its bounds' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ defaults = @{ code = @{ length = 501 } } }) } | Should -Throw '*defaults.code.length 501 is outside the bounds 100 to 500*'
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ languages = @{ widget = @{ width = 79 } } }) } | Should -Throw '*languages.widget.width 79*'
    }

    It 'checks the defaults against narrowed bounds' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ bounds = @{ width = @{ max = 130 } } }) } | Should -Throw '*defaults.config.width 140*'
    }

    It 'rejects bounds whose min is above their max' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ bounds = @{ length = @{ min = 600 } } }) } | Should -Throw '*min 600 is above max 500*'
    }

    It 'reports every violation in one exception' {
        { [Catzc.Base.FileLimits.FileLimitsConfig]::new(@{ gadget = 1; languages = @{ widget = @{ width = 9 } } }) } | Should -Throw '*unknown key*widget.width*'
    }
}

Describe 'FileLimitsConfig (shipped file-limits.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped file-limits.yml as a FileLimitsConfig' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        (Get-Config -Config file-limits) | Should -BeOfType ([Catzc.Base.FileLimits.FileLimitsConfig])
    }
}
