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

    It 'does nothing without an overlay' {
        Mock Get-CatzcOverlayRoot -ModuleName Catzc.Base.Overlay -MockWith { }
        @(Import-CatzcOverlay) | Should -BeNullOrEmpty
    }
}
