<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/tests/Import-CatzcOverlay.Tests.ps1
    kind: test
---
#>

Describe 'Import-CatzcOverlay' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Overlay.Fixture.ps1')
    }
    AfterAll {
        Remove-OverlayFixture
    }

    BeforeEach {
        Clear-OverlayFixture
        & $useFixtureRoots
    }

    It 'replaces a public and a private function for every caller' {
        Set-OverlayFile 'Catzc.Base.Widget/Get-Widget.ps1' @'
function Get-Widget {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [int] $Count
    )
    "overridden:$(Get-WidgetCore)"
}
'@
        Set-OverlayFile 'Catzc.Base.Widget/private/Get-WidgetCore.ps1' "function Get-WidgetCore {`n    [OutputType([string])]`n    param()`n    'core2'`n}"

        $applied = @(Import-CatzcOverlay)

        @($applied | ForEach-Object Target) | Should -Be @('Get-Widget', 'Get-WidgetCore')
        # The session, through the published override, and the module's own private function, through its scope.
        Get-Widget -Name lever | Should -Be 'overridden:core2'
        (Get-Command Get-Widget).ModuleName | Should -Be 'Catzc.Base.Widget'
        & (Get-Module Catzc.Base.Widget) { Get-WidgetCore } | Should -Be 'core2'
    }

    It 'applies nothing when the overlay breaks a rule' {
        Set-OverlayFile 'Catzc.Base.Widget/Get-Widget.ps1' "function Get-Widget {`n    [OutputType([string])]`n    param()`n    'overridden'`n}"
        $before = (Get-Command Get-Widget).Definition
        { Import-CatzcOverlay } | Should -Throw -ExpectedMessage '*drops parameter -Name*'
        (Get-Command Get-Widget).Definition | Should -Be $before
    }

    Context 'a local module' {
        BeforeEach {
            # Config discovery and the content lookup reach the fixture overlay through their own seams; the config
            # index is rebuilt so it scans the fixture.
            Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith { $overlayRoot }
            Mock Get-CatzcOverlayRoot -ModuleName Catzc.Base.Repository -MockWith { $overlayRoot }
            & (Get-Module Catzc.Base.Config) { $script:configIndex = $null; $script:configCache = $null }
        }
        AfterEach {
            Remove-Module Widget.Local -Force -ErrorAction Ignore
            & (Get-Module Catzc.Base.Config) { $script:configIndex = $null; $script:configCache = $null }
        }

        It 'loads after the overrides, exporting its public functions only, with its config and folder found in the overlay' {
            Set-OverlayFile 'Catzc.Base.Widget/Get-Widget.ps1' @'
function Get-Widget {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [int] $Count
    )
    'overridden'
}
'@
            Set-OverlayFile 'Widget.Local/Get-Local.ps1' "function Get-Local {`n    `"`$(Get-LocalCore):`$(Get-Widget -Name lever):`$((Get-Config -Config widget-local).limit)`"`n}"
            Set-OverlayFile 'Widget.Local/private/Get-LocalCore.ps1' "function Get-LocalCore {`n    'local-core'`n}"
            Set-OverlayFile 'Widget.Local/configs/widget-local.yml' 'limit: 7'

            $applied = @(Import-CatzcOverlay)

            @($applied | ForEach-Object Kind) | Should -Be @('FunctionOverride', 'LocalModule')
            # Its private function, the bundle as overridden, and its own config.
            Get-Local | Should -Be 'local-core:overridden:7'
            @((Get-Module Widget.Local).ExportedFunctions.Keys) | Should -Be @('Get-Local')
            Get-CatzcModuleRoot -Module Widget.Local | Should -Be ([System.IO.Path]::Combine($overlayRoot, 'Widget.Local'))
        }

        It 'replaces the module a previous load built' {
            Set-OverlayFile 'Widget.Local/Get-Local.ps1' "function Get-Local {`n    'first'`n}"
            $null = Import-CatzcOverlay
            Set-OverlayFile 'Widget.Local/Get-Local.ps1' "function Get-Local {`n    'second'`n}"
            $null = Import-CatzcOverlay
            Get-Local | Should -Be 'second'
            @(Get-Module Widget.Local).Count | Should -Be 1
        }
    }

    It 'does nothing without an overlay' {
        Mock Get-CatzcOverlayRoot -ModuleName Catzc.Base.Overlay -MockWith { }
        @(Import-CatzcOverlay) | Should -BeNullOrEmpty
    }
}
