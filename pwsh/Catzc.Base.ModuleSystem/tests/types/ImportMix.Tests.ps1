Describe 'ImportMix' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:auto = [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{})
        $script:known = [string[]] @('widget', 'gadget', 'sprocket')
        $script:executable = [string[]] @('widget', 'gadget')
        $script:modules = [ordered]@{
            'Widget.Beta'  = [string[]] @('widget', 'sprocket')
            'Widget.Alpha' = [string[]] @('gadget')
        }
    }

    It 'resolves auto engines to the present engines and reports the missing ones' -Tag 'ADR-AUTO-IMPORTER-DECIDESMIX' {
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, $null, [string[]] @('bash', 'pwsh'), $modules, $known, $executable)
        $mix.engines | Should -Be @('pwsh', 'bash')
        $mix.skipped_engines | Should -Be @('zsh')
    }

    It 'resolves auto languages to the executable languages of the modules, in configuration order' -Tag 'ADR-AUTO-IMPORTER-DECIDESMIX' {
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, $null, [string[]] @('pwsh'), $modules, $known, $executable)
        $mix.languages | Should -Be @('widget', 'gadget')
    }

    It 'lists every module in ordinal order' -Tag 'ADR-AUTO-IMPORTER-ONEMIXRECORD' {
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, $null, [string[]] @('pwsh'), $modules, $known, $executable)
        $mix.modules | Should -Be @('Widget.Alpha', 'Widget.Beta')
    }

    It 'takes the configuration''s explicit lists over auto' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = @('sprocket'); engines = @('pwsh') })
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($config, $null, $null, [string[]] @('pwsh', 'bash'), $modules, $known, $executable)
        $mix.languages | Should -Be @('sprocket')
        $mix.engines | Should -Be @('pwsh')
        $mix.skipped_engines | Should -BeNullOrEmpty
    }

    It 'takes the caller''s values over the configuration' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = @('sprocket'); engines = @('pwsh') })
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($config, [string[]] @('gadget', 'widget'), [string[]] @('bash', 'pwsh'),
            [string[]] @('pwsh', 'bash'), $modules, $known, $executable)
        $mix.languages | Should -Be @('widget', 'gadget')
        $mix.engines | Should -Be @('pwsh', 'bash')
    }

    It 'stops on an explicit engine whose executable is not present' {
        { [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, [string[]] @('zsh'), [string[]] @('pwsh'), $modules, $known, $executable) } |
            Should -Throw '*names the engine ''zsh'', but its executable is not present*'
    }

    It 'stops on an explicit engine outside the engine model' {
        { [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, [string[]] @('gadget'), [string[]] @('pwsh'), $modules, $known, $executable) } |
            Should -Throw '*''gadget'' is not an execution engine*'
    }

    It 'stops on an explicit language the languages configuration does not know, naming the known ones' {
        { [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, [string[]] @('gizmo'), $null, [string[]] @('pwsh'), $modules, $known, $executable) } |
            Should -Throw '*''gizmo'' is not a language*(one of: widget, gadget, sprocket)*'
    }

    It 'rejects a missing configuration' {
        { [Catzc.Base.ModuleSystem.ImportMix]::Resolve($null, $null, $null, $null, $null, $null, $null) } | Should -Throw '*config*'
    }
}
