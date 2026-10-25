<#
---
catzc:
  docs: "../../../docs/references/pwsh/internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1.md"
  warning: "Generated Header"
---
#>

BeforeAll {
    # The transient importer modules are removed after every import, so this test file loads its own copies.
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
    Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Importer.psm1') -Force

    # Imports a one-function fixture module <Name>.psm1 from <Folder> (its ModuleBase) into the global session.
    function Import-FixtureModule {
        param([string] $Folder, [string] $Name)
        [System.IO.Directory]::CreateDirectory($Folder) | Out-Null
        $path = Join-Path $Folder "$Name.psm1"
        [System.IO.File]::WriteAllText($path, "function Get-$($Name.Replace('.', '')) { 'ok' }")
        Import-Module $path -Scope Global -Force -PassThru
    }

    $script:runId = [guid]::NewGuid().ToString('N').Substring(0, 8)
}

AfterAll {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
    Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
}

Describe 'Get-ForeignCatzcModule' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:packageRoot = Join-Path $TestDrive 'package'
        $script:activeRoot = Join-Path $packageRoot 'widget-modules'
        $script:otherRoot = Join-Path $TestDrive 'other/widget-modules'
        $script:widget = "Catzc.Widget$runId"
        $script:gadget = "Catzc.Gadget$runId"
        $script:internalGadget = "Catzc.Internal.Gadget$runId"
        $script:tool = "WidgetTool$runId"
        $script:fixtures = @(
            Import-FixtureModule -Folder (Join-Path $activeRoot $widget) -Name $widget
            Import-FixtureModule -Folder (Join-Path $otherRoot $gadget) -Name $gadget
            Import-FixtureModule -Folder (Join-Path $otherRoot '.internal') -Name $internalGadget
            Import-FixtureModule -Folder (Join-Path $otherRoot $tool) -Name $tool
        )
        # Only import the package fixture when no real 'Catzc' package module is loaded in this session.
        $script:hasPackage = -not (Get-Module Catzc)
        if ($hasPackage) {
            $script:fixtures += Import-FixtureModule -Folder $packageRoot -Name 'Catzc'
        }
    }

    AfterAll {
        foreach ($module in $fixtures) {
            Remove-Module -ModuleInfo $module -Force -ErrorAction SilentlyContinue
        }
    }

    It 'returns a catzc module loaded from another root' {
        @((Get-ForeignCatzcModule -ModulesRoot $activeRoot).Name) | Should -Contain $gadget
    }

    It 'does not return a catzc module loaded from the active root' {
        @((Get-ForeignCatzcModule -ModulesRoot $activeRoot).Name) | Should -Not -Contain $widget
    }

    It 'ignores a module outside the catzc name space (vendored and third-party modules)' {
        @((Get-ForeignCatzcModule -ModulesRoot $activeRoot).Name) | Should -Not -Contain $tool
    }

    It 'includes Catzc.Internal.* modules only under -IncludeInternal' {
        @((Get-ForeignCatzcModule -ModulesRoot $activeRoot).Name) | Should -Not -Contain $internalGadget
        @((Get-ForeignCatzcModule -ModulesRoot $activeRoot -IncludeInternal).Name) | Should -Contain $internalGadget
    }

    It 'compares roots normalized: a trailing separator and letter case do not change the answer' {
        $variant = $activeRoot.ToUpperInvariant() + [System.IO.Path]::DirectorySeparatorChar
        if (-not $IsWindows) {
            $variant = $activeRoot + '/'
        }
        @((Get-ForeignCatzcModule -ModulesRoot $variant).Name) | Should -Not -Contain $widget
        @((Get-ForeignCatzcModule -ModulesRoot $variant).Name) | Should -Contain $gadget
    }

    It 'treats the package module Catzc at the root''s parent as belonging to that root' {
        if (-not $hasPackage) {
            Set-ItResult -Skipped -Because 'session_has_catzc_package'; return
        }
        @((Get-ForeignCatzcModule -ModulesRoot $activeRoot).Name) | Should -Not -Contain 'Catzc'
        @((Get-ForeignCatzcModule -ModulesRoot $otherRoot).Name) | Should -Contain 'Catzc'
    }
}

Describe 'Assert-CatzcRunModeExclusive' -Tag 'L0', 'logic' {
    It 'passes when no catzc module comes from another root' {
        Mock Get-ForeignCatzcModule { @() } -ModuleName Catzc.Internal.Importer
        { InModuleScope Catzc.Internal.Importer { Assert-CatzcRunModeExclusive -ModulesRoot 'C:/active/automation' } } | Should -Not -Throw
    }

    It 'asks the shared predicate for internal modules too' {
        Mock Get-ForeignCatzcModule { @() } -ModuleName Catzc.Internal.Importer
        InModuleScope Catzc.Internal.Importer { Assert-CatzcRunModeExclusive -ModulesRoot 'C:/active/automation' }
        Should -Invoke Get-ForeignCatzcModule -ModuleName Catzc.Internal.Importer -ParameterFilter { $IncludeInternal }
    }

    It 'throws naming every offender, its ModuleBase, the active root, and the other root' {
        Mock Get-ForeignCatzcModule {
            [pscustomobject]@{ Name = 'Catzc.Widget'; ModuleBase = 'C:/other/pwsh/Catzc.Widget' }
            [pscustomobject]@{ Name = 'Catzc.Gadget'; ModuleBase = 'C:/other/pwsh/Catzc.Gadget' }
        } -ModuleName Catzc.Internal.Importer
        $message = $null
        try {
            InModuleScope Catzc.Internal.Importer { Assert-CatzcRunModeExclusive -ModulesRoot 'C:/active/automation' }
        }
        catch {
            $message = $_.Exception.Message
        }
        $message | Should -BeLike "*active CatzcModulesRoot is 'C:/active/automation'*2 loaded catzc module(s) come from another root ('C:?other?pwsh')*"
        $message | Should -BeLike '*Catzc.Widget (C:/other/pwsh/Catzc.Widget)*'
        $message | Should -BeLike '*Catzc.Gadget (C:/other/pwsh/Catzc.Gadget)*'
    }

    It 'throws on a real catzc module loaded from outside the active root (no mock)' {
        $stray = Import-FixtureModule -Folder (Join-Path $TestDrive "stray/Catzc.Stray$runId") -Name "Catzc.Stray$runId"
        try {
            { InModuleScope Catzc.Internal.Importer -Parameters @{ R = (Get-CatzcModulesRoot) } { param($R) Assert-CatzcRunModeExclusive -ModulesRoot $R } } |
                Should -Throw "*Catzc.Stray$runId*"
        }
        finally {
            Remove-Module -ModuleInfo $stray -Force
        }
    }
}
