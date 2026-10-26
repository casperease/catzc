Describe 'ImporterConfig' -Tag 'L0', 'logic' {
    It 'takes auto for both axes when every key is omitted' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{})
        $config.languages | Should -Be @('auto')
        $config.engines | Should -Be @('auto')
        [Catzc.Base.ModuleSystem.ImporterConfig]::IsAuto($config.languages) | Should -BeTrue
    }

    It 'takes the defaults from a missing file as well' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        ([Catzc.Base.ModuleSystem.ImporterConfig]::new($null)).engines | Should -Be @('auto')
    }

    It 'maps explicit lists for both axes' {
        $config = [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = @('widget',
            'gadget'); engines = [Catzc.Base.Engines.ExecutionEngines]::Names[0..1] })
        $config.languages | Should -Be @('widget', 'gadget')
        $config.engines | Should -Be ([Catzc.Base.Engines.ExecutionEngines]::Names[0..1])
        [Catzc.Base.ModuleSystem.ImporterConfig]::IsAuto($config.engines) | Should -BeFalse
    }

    It 'rejects an unknown key, naming the allowed set' {
        { [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ gadget = 1 }) } |
            Should -Throw '*unknown key ''gadget''*languages, engines*'
    }

    It 'rejects a string other than auto' {
        { [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = 'widget' }) } |
            Should -Throw '*languages ''widget'' must be auto or a list*'
    }

    It 'rejects an empty list or a map' {
        { [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ engines = @() }) } |
            Should -Throw '*engines must be auto or a non-empty list*'
        { [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = @{ widget = 1 } }) } |
            Should -Throw '*non-empty list*'
    }

    It 'rejects auto mixed into a list, a blank entry and a repeated entry' {
        { [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = @('auto', 'widget') }) } |
            Should -Throw '*auto stands alone*'
        { [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = @(' ') }) } | Should -Throw '*not blank*'
        { [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = @('widget', 'widget') }) } |
            Should -Throw '*lists ''widget'' twice*'
    }

    It 'rejects an engine outside the engine model, naming the engines' {
        { [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ engines = @('gadget') }) } |
            Should -Throw '*''gadget'' is not an execution engine (one of: pwsh, bash, zsh)*'
    }

    It 'reports every violation in one exception' {
        { [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ engines = @('gadget'); widget = 1 }) } |
            Should -Throw '*unknown key*not an execution engine*'
    }
}

Describe 'ImporterConfig (shipped importer.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped importer.yml as an ImporterConfig' -Tag 'ADR-AUTO-IMPORTER-DECIDESMIX' {
        (Get-Config -Config importer) | Should -BeOfType ([Catzc.Base.ModuleSystem.ImporterConfig])
    }
}
