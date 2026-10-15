<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1
    kind: pester-test
---
#>

# Get-ConfigRegistry is private, so it is exercised through the module (InModuleScope, per
# [ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)).
# Each test resets the session's cache entry before and after
# ([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)), so a fixture
# registry never
# leaks into the rest of the run.
Describe 'Get-ConfigRegistry' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixtureRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:fixtureRoot) | Out-Null
        $script:fixturePath = Join-Path $script:fixtureRoot 'configs.yml'
        [System.IO.File]::WriteAllText($script:fixturePath, "configs:`n  widget:`n    type: Catzc.Widget.WidgetConfig`n  gadget:`n    type: Catzc.Gadget.GadgetConfig`n")
    }

    AfterEach {
        InModuleScope Catzc.Base.Config { $script:configRegistryCache = $null }
    }

    It 'returns the configs map of the registry file the module root resolves' {
        Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.Config -ParameterFilter { $ChildPath -eq 'configs/configs.yml' } -MockWith { $script:fixturePath }
        $registry = InModuleScope Catzc.Base.Config { $script:configRegistryCache = $null; Get-ConfigRegistry }
        @($registry.Keys) | Should -Be @('widget', 'gadget')
        $registry['widget']['type'] | Should -Be 'Catzc.Widget.WidgetConfig'
    }

    It 'returns an empty map when the module ships no registry file' {
        $missingPath = Join-Path $script:fixtureRoot 'absent.yml'
        Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.Config -ParameterFilter { $ChildPath -eq 'configs/configs.yml' } -MockWith { $missingPath }
        $registry = InModuleScope Catzc.Base.Config { $script:configRegistryCache = $null; Get-ConfigRegistry }
        @($registry.Keys).Count | Should -Be 0
    }

    It 'memoizes the registry for the session' {
        Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.Config -ParameterFilter { $ChildPath -eq 'configs/configs.yml' } -MockWith { $script:fixturePath }
        InModuleScope Catzc.Base.Config { $script:configRegistryCache = $null; Get-ConfigRegistry | Out-Null; Get-ConfigRegistry | Out-Null }
        Should -Invoke Get-CatzcModuleRoot -ModuleName Catzc.Base.Config -Times 1 -Exactly
    }
}

# Reads the SHIPPED configs.yml through the real lookup (nothing mocked), so it runs in both the source run
# and the build run and proves the registry resolves inside the loaded module
# ([ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3)).
Describe 'Get-ConfigRegistry — shipped configs.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    AfterAll {
        InModuleScope Catzc.Base.Config { $script:configRegistryCache = $null }
    }

    It 'loads and self-validates the registry shipped in the loaded module' {
        $registry = InModuleScope Catzc.Base.Config { $script:configRegistryCache = $null; Get-ConfigRegistry }
        $shippedPath = Get-CatzcModuleRoot 'configs/configs.yml' -Module Catzc.Base.Config
        $shipped = [System.IO.File]::ReadAllText($shippedPath) | ConvertFrom-Yaml -Ordered

        @($registry.Keys).Count | Should -BeGreaterThan 0 -Because 'the shipped registry is found, not the empty no-file fallback'
        @($registry.Keys) | Should -Be @($shipped['configs'].Keys)
        $registry['configs']['type'] | Should -Be 'Catzc.Base.Config.ConfigsConfig' -Because 'the registry registers its own validator'
    }
}
