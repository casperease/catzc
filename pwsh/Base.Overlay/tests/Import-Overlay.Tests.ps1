Describe 'Import-Overlay' -Tag 'L0', 'logic' {
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
        Set-OverlayFile 'Base.Widget/Get-Widget.ps1' @'
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
        Set-OverlayFile 'Base.Widget/private/Get-WidgetCore.ps1' "function Get-WidgetCore {`n    [OutputType([string])]`n    param()`n    'core2'`n}"

        $applied = @(Import-Overlay)

        @($applied | ForEach-Object Target) | Should -Be @('Get-Widget', 'Get-WidgetCore')
        # The session, through the published override, and the module's own private function, through its scope.
        Get-Widget -Name lever | Should -Be 'overridden:core2'
        (Get-Command Get-Widget).ModuleName | Should -Be 'Catzc.Base.Widget'
        & (Get-Module Catzc.Base.Widget) { Get-WidgetCore } | Should -Be 'core2'
    }

    It 'applies an override of a bundled module in a built root, where the folder carries the namespace' {
        & $useBuiltRoot
        Set-OverlayFile 'Base.Widget/Get-Widget.ps1' "function Get-Widget {`n    [OutputType([string])]`n    param(`n        [Parameter(Mandatory)]`n        [string] `$Name,`n`n        [int] `$Count`n    )`n    'built'`n}"
        Set-OverlayFile 'Base.Widget/configs/widget.yml' 'limit: 5'

        $applied = @(Import-Overlay)

        @($applied | ForEach-Object Target) | Should -Be @('Get-Widget')
        Get-Widget -Name lever | Should -Be 'built'
    }

    It 'applies nothing when the overlay breaks a rule' {
        Set-OverlayFile 'Base.Widget/Get-Widget.ps1' "function Get-Widget {`n    [OutputType([string])]`n    param()`n    'overridden'`n}"
        $before = (Get-Command Get-Widget).Definition
        { Import-Overlay } | Should -Throw -ExpectedMessage '*drops parameter -Name*'
        (Get-Command Get-Widget).Definition | Should -Be $before
    }

    It 'loads nothing from a folder that names no bundled module and throws, pointing at the consumer''s tracks' {
        Set-OverlayFile 'Widget.Local/Get-Local.ps1' "function Get-Local {`n    'local'`n}"

        { Import-Overlay } | Should -Throw -ExpectedMessage '*names no bundled module*'
        Get-Module Widget.Local | Should -BeNullOrEmpty
        Get-Command Get-Local -ErrorAction Ignore | Should -BeNullOrEmpty
    }

    It 'does nothing without an overlay' {
        Mock Get-OverlayRoot -ModuleName Catzc.Base.Overlay -MockWith { }
        @(Import-Overlay) | Should -BeNullOrEmpty
    }
}
