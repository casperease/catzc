<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/tests/Assert-CatzcOverlay.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Overlay
    relatives:
      source: automation/Catzc.Base.Overlay/Assert-CatzcOverlay.ps1
    adrs:
      - ADR-AUTO-OVERLAY
---
#>

Describe 'Assert-CatzcOverlay' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Overlay.Fixture.ps1')
        $script:validOverride = @'
function Get-Widget {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [int] $Count,

        [switch] $Loud
    )
    'overridden'
}
'@
    }
    AfterAll {
        Remove-OverlayFixture
    }

    BeforeEach {
        Clear-OverlayFixture
        & $useFixtureRoots
    }

    It 'passes a valid overlay: overrides, a fragment, an asset, a test' {
        Set-OverlayFile 'Catzc.Base.Widget/Get-Widget.ps1' $validOverride
        Set-OverlayFile 'Catzc.Base.Widget/private/Get-WidgetCore.ps1' "function Get-WidgetCore {`n    [OutputType([string])]`n    param()`n    'core2'`n}"
        Set-OverlayFile 'Catzc.Base.Widget/configs/widget.yml' 'limit: 5'
        Set-OverlayFile 'Catzc.Base.Widget/assets/lever.txt' 'consumer'
        Set-OverlayFile 'Catzc.Base.Widget/tests/Get-Widget.Tests.ps1' "Describe 'x' { }"
        Set-OverlayFile 'Widget.Local/Get-Local.ps1' 'function Get-Local { }'
        Set-OverlayFile 'Widget.Local/private/Get-LocalCore.ps1' 'function Get-LocalCore { }'
        Set-OverlayFile 'Widget.Local/configs/widget-local.yml' 'limit: 1'
        Set-OverlayFile 'Widget.Local/tests/Get-Local.Tests.ps1' "Describe 'x' { }"
        { Assert-CatzcOverlay } | Should -Not -Throw
    }

    It 'passes when there is no overlay' {
        Mock Get-CatzcOverlayRoot -ModuleName Catzc.Base.Overlay -MockWith { }
        { Assert-CatzcOverlay } | Should -Not -Throw
    }

    It 'rejects <Case>' -ForEach @(
        @{ Case = 'an entry that is no override point'; File = 'Catzc.Base.Widget/types/Lever.cs'; Content = 'class Lever { }'; Expected = '*Catzc.Base.Widget/types/Lever.cs: not an override point*' }
        @{ Case = 'an override of a function the module lacks'; File = 'Catzc.Base.Widget/Get-Gadget.ps1'; Content = "function Get-Gadget {`n    param()`n}"; Expected = '*Catzc.Base.Widget has no function Get-Gadget to override*' }
        @{ Case = 'a public function overridden under private/'; File = 'Catzc.Base.Widget/private/Get-Widget.ps1'; Content = "function Get-Widget {`n    param()`n}"; Expected = '*Get-Widget is public in Catzc.Base.Widget*' }
        @{ Case = 'a private function overridden at the root'; File = 'Catzc.Base.Widget/Get-WidgetCore.ps1'; Content = "function Get-WidgetCore {`n    param()`n}"; Expected = '*Get-WidgetCore is private in Catzc.Base.Widget*' }
        @{ Case = 'an override file that is not one function'; File = 'Catzc.Base.Widget/Get-Widget.ps1'; Content = "function Get-Widget { }`n" + 'function Get-Gizmo { }'; Expected = '*must hold exactly one top-level statement*' }
        @{ Case = 'a fragment of a sealed config'; File = 'Catzc.Base.Widget/configs/gadget.yml'; Content = 'limit: 5'; Expected = "*config 'gadget' is sealed*" }
        @{ Case = 'a fragment of a config the module does not ship'; File = 'Catzc.Base.Widget/configs/gizmo.yml'; Content = 'limit: 5'; Expected = "*ships no config 'gizmo' to merge onto*" }
        @{ Case = 'an asset the module does not ship'; File = 'Catzc.Base.Widget/assets/gizmo.txt'; Content = 'new'; Expected = '*ships no asset assets/gizmo.txt to replace*' }
        @{ Case = 'a local module with the reserved prefix'; File = 'Catzc.Base.Gadget/Get-Gadget.ps1'; Content = 'function Get-Gadget { }'; Expected = '*the Catzc. prefix is reserved*' }
        @{ Case = 'a local module carrying types/'; File = 'Widget.Local/types/Lever.cs'; Content = 'class Lever { }'; Expected = '*a local module carries no types/*' }
        @{ Case = 'a local function file that is not one function'; File = 'Widget.Local/Get-Local.ps1'; Content = "function Get-Local { }`n" + 'function Get-Other { }'; Expected = '*Widget.Local/Get-Local.ps1: must hold exactly one top-level statement*' }
        @{ Case = 'a local public function that takes a loaded command''s name'; File = 'Widget.Local/Get-Widget.ps1'; Content = 'function Get-Widget { }'; Expected = '*public function Get-Widget takes the name of a command already loaded from Catzc.Base.Widget*' }
        @{ Case = 'a local module entry that is not part of a module'; File = 'Widget.Local/notes.txt'; Content = 'notes'; Expected = '*Widget.Local/notes.txt: not part of a module*' }
        @{ Case = 'a local module with no function file'; File = 'Widget.Local/configs/widget-local.yml'; Content = 'limit: 1'; Expected = '*Widget.Local: a local module has at least one function file*' }
    ) {
        Set-OverlayFile $File $Content
        { Assert-CatzcOverlay } | Should -Throw -ExpectedMessage $Expected
    }

    It 'rejects an override that breaks the contract: <Case>' -ForEach @(
        @{ Case = 'a dropped parameter'; Params = "[Parameter(Mandatory)]`n        [string] `$Name"; Output = '[OutputType([string])]'; Expected = '*drops parameter -Count of Get-Widget*' }
        @{ Case = 'a changed type'; Params = "[Parameter(Mandatory)]`n        [string] `$Name,`n        [string] `$Count"; Output = '[OutputType([string])]'; Expected = '*declares -Count as `[System.String`], but Get-Widget declares `[System.Int32`]*' }
        @{ Case = 'a new mandatory parameter'; Params = "[Parameter(Mandatory)]`n        [string] `$Name,`n        [int] `$Count,`n        [Parameter(Mandatory)]`n        [string] `$Gadget"; Output = '[OutputType([string])]'; Expected = '*makes -Gadget mandatory*' }
        @{ Case = 'another output type'; Params = "[Parameter(Mandatory)]`n        [string] `$Name,`n        [int] `$Count"; Output = '[OutputType([int])]'; Expected = '*declares `[OutputType(System.Int32)`], but Get-Widget declares `[OutputType(System.String)`]*' }
    ) {
        Set-OverlayFile 'Catzc.Base.Widget/Get-Widget.ps1' "function Get-Widget {`n    $Output`n    param(`n        $Params`n    )`n    'overridden'`n}"
        { Assert-CatzcOverlay } | Should -Throw -ExpectedMessage $Expected
    }

    It 'reports every violation in one throw' {
        Set-OverlayFile 'Catzc.Base.Widget/types/Lever.cs' 'class Lever { }'
        Set-OverlayFile 'Catzc.Base.Widget/configs/gadget.yml' 'limit: 5'
        $failure = { Assert-CatzcOverlay } | Should -Throw -PassThru
        $failure.Exception.Message | Should -BeLike '*breaks 2 rule(s) of ADR-AUTO-OVERLAY*'
        $failure.Exception.Message | Should -BeLike '*not an override point*'
        $failure.Exception.Message | Should -BeLike "*config 'gadget' is sealed*"
    }
}
