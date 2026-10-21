<#
---
catzc:
  immutable:
    with_body_sha: "8be0c02322e7"
  edges:
    docs: "[Get-ConfigRegistry.Tests.ps1.md](docs/references/pwsh/catzc-base-config/tests/Get-ConfigRegistry.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Config/private/Get-ConfigRegistry.ps1
    cites:
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
      - ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES
      - ADR-PWSH-PESTER-PRIVATETHROUGHMODULE
---
#>

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

Describe 'Get-ConfigRegistry — shipped configs.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
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
