<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Get-CatsModules.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-ASSETDEP#3
      - ADR-PWSH-PESTER#4
---
#>

# Get-CatsModules is private, so it is exercised through the module (& (Get-Module …), per ).
# [comment:1](/docs/references/automation/catzc-base-docs/tests/Get-CatsModules.Tests.ps1.md#comment1)
Describe 'Get-CatsModules' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fixture modules loaded from a fixture code root: two catzc-shaped modules, one dot-prefixed infrastructure...
        # [comment:2](/docs/references/automation/catzc-base-docs/tests/Get-CatsModules.Tests.ps1.md#comment2)
        $script:modulesRoot = Join-Path $TestDrive 'modules'
        $outsideRoot = Join-Path $TestDrive 'elsewhere'
        $fixtures = @(
            @{ Root = $script:modulesRoot; Name = 'Catzc.Widget.Reader'; Body = @('function Get-WidgetReport {}', 'function Set-WidgetReport {}', 'function Get-WidgetHelper {}', 'Export-ModuleMember -Function Set-WidgetReport, Get-WidgetReport') -join "`n" }
            @{ Root = $script:modulesRoot; Name = 'Catzc.Gadget.Writer'; Body = "function Invoke-GadgetBackup {}`nExport-ModuleMember -Function Invoke-GadgetBackup" }
            @{ Root = $script:modulesRoot; Name = '.widget'; Body = "function Get-HiddenWidget {}`nExport-ModuleMember -Function Get-HiddenWidget" }
            @{ Root = $outsideRoot; Name = 'Catzc.Gadget.Outside'; Body = "function Get-OutsideGadget {}`nExport-ModuleMember -Function Get-OutsideGadget" }
        )
        $script:fixtureNames = foreach ($fixture in $fixtures) {
            $folder = Join-Path $fixture.Root $fixture.Name
            [System.IO.Directory]::CreateDirectory($folder) | Out-Null
            $modulePath = Join-Path $folder "$($fixture.Name).psm1"
            [System.IO.File]::WriteAllText($modulePath, $fixture.Body)
            Import-Module $modulePath -Global -Force
            $fixture.Name
        }

        $script:modules = & (Get-Module Catzc.Base.Docs) { param($root) Get-CatsModules -ModulesRoot $root } $script:modulesRoot
    }

    AfterAll {
        Remove-Module -Name $script:fixtureNames -Force -ErrorAction Ignore
    }

    It 'lists the loaded modules under the code root, sorted by name' {
        @($script:modules.Module) | Should -Be @('Catzc.Gadget.Writer', 'Catzc.Widget.Reader')
    }

    It 'lists each module''s exported functions, sorted' {
        ($script:modules | Where-Object { $_.Module -eq 'Catzc.Widget.Reader' }).Functions | Should -Be @('Get-WidgetReport', 'Set-WidgetReport')
    }

    It 'leaves out functions the module does not export' {
        ($script:modules | Where-Object { $_.Module -eq 'Catzc.Widget.Reader' }).Functions | Should -Not -Contain 'Get-WidgetHelper'
    }

    It 'leaves out dot-prefixed infrastructure modules and modules loaded from another root' {
        $script:modules.Module | Should -Not -Contain '.widget'
        $script:modules.Module | Should -Not -Contain 'Catzc.Gadget.Outside'
    }
}

# Reads the REAL loaded session (nothing mocked), so it runs in both the source run and the build run and proves...
# [comment:3](/docs/references/automation/catzc-base-docs/tests/Get-CatsModules.Tests.ps1.md#comment3)
Describe 'Get-CatsModules — loaded catzc modules' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    BeforeAll {
        $script:modules = & (Get-Module Catzc.Base.Docs) { Get-CatsModules }
    }

    It 'lists this module with exactly the functions it exports' {
        $docs = $script:modules | Where-Object { $_.Module -eq 'Catzc.Base.Docs' }
        $docs | Should -Not -BeNullOrEmpty
        $docs.Functions | Should -Contain 'Show-Cats'
        $docs.Functions | Should -Be @((Get-Module Catzc.Base.Docs).ExportedFunctions.Keys | Sort-Object)
    }

    It 'never lists a private function' {
        ($script:modules | Where-Object { $_.Module -eq 'Catzc.Base.Docs' }).Functions | Should -Not -Contain 'Get-CatsModules'
    }

    It 'lists only modules loaded from the code root, never the dot-prefixed infrastructure' {
        $root = [System.IO.Path]::GetFullPath((Get-CatzcModulesRoot)).TrimEnd('\', '/')
        $violations = foreach ($entry in $script:modules) {
            $base = [System.IO.Path]::GetFullPath((Get-Module $entry.Module).ModuleBase).TrimEnd('\', '/')
            if ([System.IO.Path]::GetDirectoryName($base) -ine $root) {
                "$($entry.Module) is loaded from $base, not from the code root $root"
            }
        }
        @($violations) | Should -BeNullOrEmpty
        @($script:modules.Module | Where-Object { $_ -like 'Catzc.Internal.*' }) | Should -BeNullOrEmpty
    }
}
