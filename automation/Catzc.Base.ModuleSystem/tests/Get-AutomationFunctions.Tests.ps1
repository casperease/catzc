<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/tests/Get-AutomationFunctions.Tests.ps1
    folder: tests
    name: get-automation-functions-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-AutomationFunctions' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-AutomationModules -ModuleName Catzc.Base.ModuleSystem { @('Catzc.Base.Widget') }
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

    It 'lists the exported functions of the loaded automation modules only, sorted' {
        $functions = @(Get-AutomationFunctions -AutomationRoot $TestDrive)
        $functions.Function | Should -Be @('Get-Gadget', 'Set-Gadget')
        $functions.Module | Should -Not -Contain 'Foreign.Module'
    }

    It 'defaults the module list to the loaded code root' {
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.ModuleSystem { 'C:/widget/build/Catzc/6.6.666' }
        Get-AutomationFunctions | Out-Null
        Should -Invoke Get-AutomationModules -ModuleName Catzc.Base.ModuleSystem -ParameterFilter {
            $AutomationRoot -eq 'C:/widget/build/Catzc/6.6.666'
        }
    }

    It 'with -NotUsedInternally drops the functions another automation function calls' {
        Mock Get-CatzcRunMode { 'source' } -ModuleName Catzc.Base.Repository
        (Get-AutomationFunctions -NotUsedInternally -AutomationRoot $TestDrive).Function | Should -Be 'Get-Gadget'
    }

    It 'lists the loaded functions in build mode, but -NotUsedInternally stops with a named error there' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        @(Get-AutomationFunctions -AutomationRoot $TestDrive).Count | Should -Be 2
        { Get-AutomationFunctions -NotUsedInternally -AutomationRoot $TestDrive } |
            Should -Throw '*Get-AutomationFunctions operates on the catzc source tree*'
    }
}
