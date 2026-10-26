Describe 'ImportMix' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:auto = [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{})
        $script:pwshBash = [string[]] [Catzc.Base.Engines.ExecutionEngines]::Names[0..1]
        $script:bashPwsh = [string[]] [Catzc.Base.Engines.ExecutionEngines]::Names[1, 0]
        $script:known = [string[]] @('widget', 'gadget', 'sprocket', 'doodad')
        $script:executable = [string[]] @('widget', 'gadget')
        $script:handled = [string[]] @('widget', 'gadget', 'sprocket')
        $script:modules = [ordered]@{
            'Widget.Beta'  = [string[]] @('widget', 'sprocket')
            'Widget.Alpha' = [string[]] @('gadget')
        }
    }

    It 'resolves auto engines to the present engines and reports the missing ones' -Tag 'ADR-AUTO-IMPORTER-DECIDESMIX' {
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, $null, $bashPwsh, $modules, $known,
            $executable, $handled)
        $mix.engines | Should -Be $pwshBash
        $mix.skipped_engines | Should -Be @('zsh')
    }

    It 'resolves auto languages to the executable languages of the modules, in configuration order' -Tag 'ADR-AUTO-IMPORTER-DECIDESMIX' {
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, $null, [string[]] @('pwsh'), $modules, $known,
            $executable, $handled)
        $mix.languages | Should -Be @('widget', 'gadget')
    }

    It 'lists every module in ordinal order when auto takes in every code language' -Tag 'ADR-AUTO-IMPORTER-ONEMIXRECORD' {
        $code = [ordered]@{ 'Widget.Beta' = [string[]] @('widget'); 'Widget.Alpha' = [string[]] @('gadget'); 'Widget.Gamma' = [string[]] @() }
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, $null, [string[]] @('pwsh'), $code, $known,
            $executable, $handled)
        $mix.modules | Should -Be @('Widget.Alpha', 'Widget.Beta', 'Widget.Gamma')
        $mix.skipped_modules | Should -BeNullOrEmpty
    }

    It 'leaves out a module with a code language outside the mix' -Tag 'ADR-AUTO-IMPORTER-CODELANGUAGESSELECTMODULES' {
        $code = [ordered]@{ 'Widget.Beta' = [string[]] @('widget',
            'gadget'); 'Widget.Alpha' = [string[]] @('widget'); 'Widget.Gamma' = [string[]] @() }
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, [string[]] @('widget'), $null, [string[]] @('pwsh'),
            $code, $known, $executable, $handled)
        $mix.modules | Should -Be @('Widget.Alpha', 'Widget.Gamma')
        $mix.skipped_modules | Should -Be @('Widget.Beta')
    }

    It 'takes the configuration''s explicit lists over auto' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = @('sprocket'); engines = @('pwsh') })
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($config, $null, $null, $pwshBash, $modules, $known,
            $executable, $handled)
        $mix.languages | Should -Be @('sprocket')
        $mix.engines | Should -Be @('pwsh')
        $mix.skipped_engines | Should -BeNullOrEmpty
    }

    It 'takes the caller''s values over the configuration' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.ModuleSystem.ImporterConfig]::new(@{ languages = @('sprocket'); engines = @('pwsh') })
        $mix = [Catzc.Base.ModuleSystem.ImportMix]::Resolve($config, [string[]] @('gadget', 'widget'), $bashPwsh,
            $pwshBash, $modules, $known, $executable, $handled)
        $mix.languages | Should -Be @('widget', 'gadget')
        $mix.engines | Should -Be $pwshBash
    }

    It 'stops on an explicit engine whose executable is not present' {
        { [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, [string[]] @('zsh'), [string[]] @('pwsh'),
            $modules, $known, $executable, $handled) } |
            Should -Throw '*names the engine ''zsh'', but its executable is not present*'
    }

    It 'stops on an explicit engine outside the engine model' {
        { [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, $null, [string[]] @('gadget'), [string[]] @('pwsh'),
            $modules, $known, $executable, $handled) } |
            Should -Throw '*''gadget'' is not an execution engine*'
    }

    It 'stops on an explicit language the languages configuration does not know, naming the known ones' {
        { [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, [string[]] @('gizmo'), $null, [string[]] @('pwsh'),
            $modules, $known, $executable, $handled) } |
            Should -Throw '*''gizmo'' is not a language*(one of: widget, gadget, sprocket, doodad)*'
    }

    It 'stops with NotImplemented on an explicit language the importer has no handler for, naming it' -Tag 'ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS' {
        $thrown = $null
        try {
            [void] [Catzc.Base.ModuleSystem.ImportMix]::Resolve($auto, [string[]] @('doodad'), $null,
                [string[]] @('pwsh'), $modules, $known, $executable, $handled)
        }
        catch {
            $thrown = $_.Exception.GetBaseException()
        }
        $thrown | Should -BeOfType ([System.NotImplementedException])
        $thrown.Message | Should -BeLike '*language ''doodad''*no handler*(handled: widget, gadget, sprocket)*'
    }

    It 'rejects a missing configuration' {
        { [Catzc.Base.ModuleSystem.ImportMix]::Resolve($null, $null, $null, $null, $null, $null, $null, $null) } |
            Should -Throw '*config*'
    }
}
