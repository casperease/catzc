Describe 'Get-ModuleFunction' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-CatzcModule -ModuleName Catzc.Base.ModuleSystem {
            [Catzc.Base.Modules.Module]::new('Catzc.Base.Widget', 'widgets', 'widget-folder', 'widgetry',
                'widgetry/Catzc.Base.Widget', 'folder', $null, $null, $null, $null)
        }
        Mock Get-Module -ModuleName Catzc.Base.ModuleSystem {
            @(
                [pscustomobject]@{ Name = 'Catzc.Base.Widget'; ExportedFunctions = @{ 'Get-Gadget' = $null; 'Set-Gadget' = $null } }
                [pscustomobject]@{ Name = 'Foreign.Module'; ExportedFunctions = @{ 'Get-Foreign' = $null } }
            )
        }
        Mock Get-FunctionDependency -ModuleName Catzc.Base.ModuleSystem {
            @([pscustomobject]@{ TargetFunction = 'Set-Gadget' })
        }
    }

    It 'lists the exported functions of the loaded catzc modules only, sorted' {
        $functions = @(Get-ModuleFunction -ModulesRoot $TestDrive)
        $functions.Function | Should -Be @('Get-Gadget', 'Set-Gadget')
        $functions.Module | Should -Not -Contain 'Foreign.Module'
    }

    It 'completes the deferred load before it enumerates the loaded modules' -Tag 'ADR-AUTO-IMPORTER-LOADEDBYFIRSTUSE' {
        $script:order = [System.Collections.Generic.List[string]]::new()
        Mock Import-DeferredModule -ModuleName Catzc.Base.ModuleSystem { $script:order.Add('import') }
        Mock Get-Module -ModuleName Catzc.Base.ModuleSystem { $script:order.Add('enumerate'); @() }
        Get-ModuleFunction | Out-Null
        Should -Invoke Import-DeferredModule -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter { $All }
        $script:order | Should -Be @('import', 'enumerate')
    }

    It 'takes the module list from the resolver, for the code track' {
        Get-ModuleFunction | Out-Null
        Should -Invoke Get-CatzcModule -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $EngineTrack }
    }

    It 'with -NotUsedInternally drops the functions another catzc function calls' {
        Mock Get-CatzcRunMode { 'source' } -ModuleName Catzc.Base.Repository
        (Get-ModuleFunction -NotUsedInternally -ModulesRoot $TestDrive).Function | Should -Be 'Get-Gadget'
    }

    It 'lists the loaded functions in build mode, but -NotUsedInternally stops with a named error there' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        @(Get-ModuleFunction -ModulesRoot $TestDrive).Count | Should -Be 2
        { Get-ModuleFunction -NotUsedInternally -ModulesRoot $TestDrive } |
            Should -Throw '*Get-ModuleFunction runs in catzc*s source tree only*'
    }
}
