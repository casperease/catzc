Describe 'Assert-Overlay' -Tag 'L0', 'logic' {
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
        Set-OverlayFile 'Base.Widget/Get-Widget.ps1' $validOverride
        Set-OverlayFile 'Base.Widget/private/Get-WidgetCore.ps1' "function Get-WidgetCore {`n    [OutputType([string])]`n    param()`n    'core2'`n}"
        Set-OverlayFile 'Base.Widget/configs/widget.yml' 'limit: 5'
        Set-OverlayFile 'Base.Widget/assets/lever.txt' 'consumer'
        Set-OverlayFile 'Base.Widget/tests/Get-Widget.Tests.ps1' "Describe 'x' { }"
        { Assert-Overlay } | Should -Not -Throw
    }

    It 'checks a bare overlay folder against the namespaced folder of a built root' {
        & $useBuiltRoot
        Set-OverlayFile 'Base.Widget/configs/widget.yml' 'limit: 5'
        Set-OverlayFile 'Base.Widget/assets/lever.txt' 'consumer'
        { Assert-Overlay } | Should -Not -Throw

        Set-OverlayFile 'Base.Widget/configs/gizmo.yml' 'limit: 5'
        { Assert-Overlay } | Should -Throw -ExpectedMessage "*ships no config 'gizmo' to merge onto*"
    }

    It 'throws on a folder that names no bundled module, pointing at the consumer''s tracks' -Tag 'ADR-AUTO-OVERLAY-MODULEOVERRIDEENTRIES' {
        Set-OverlayFile 'Widget.Local/Get-Local.ps1' 'function Get-Local { }'
        { Assert-Overlay } | Should -Throw -ExpectedMessage '*.catzc/pwsh/Widget.Local: names no bundled module*ADR-AUTO-CONSUMER-OWNTRACKS*'
    }

    It 'passes when there is no overlay' {
        Mock Get-OverlayRoot -ModuleName Catzc.Base.Overlay -MockWith { }
        { Assert-Overlay } | Should -Not -Throw
    }

    It 'rejects <Case>' -ForEach @(
        @{ Case = 'an entry that is no override point'; File = 'Base.Widget/types/Lever.cs'; Content = 'class Lever { }'; Expected = '*Base.Widget/types/Lever.cs: not an override point*' }
        @{ Case = 'an override of a function the module lacks'; File = 'Base.Widget/Get-Gadget.ps1'; Content = "function Get-Gadget {`n    param()`n}"; Expected = '*Catzc.Base.Widget has no function Get-Gadget to override*' }
        @{ Case = 'a public function overridden under private/'; File = 'Base.Widget/private/Get-Widget.ps1'; Content = "function Get-Widget {`n    param()`n}"; Expected = '*Get-Widget is public in Catzc.Base.Widget*' }
        @{ Case = 'a private function overridden at the root'; File = 'Base.Widget/Get-WidgetCore.ps1'; Content = "function Get-WidgetCore {`n    param()`n}"; Expected = '*Get-WidgetCore is private in Catzc.Base.Widget*' }
        @{ Case = 'an override file that is not one function'; File = 'Base.Widget/Get-Widget.ps1'; Content = "function Get-Widget { }`n" + 'function Get-Gizmo { }'; Expected = '*must hold exactly one top-level statement*' }
        @{ Case = 'a fragment of a sealed config'; File = 'Base.Widget/configs/gadget.yml'; Content = 'limit: 5'; Expected = "*config 'gadget' is sealed*" }
        @{ Case = 'a fragment of a config the module does not ship'; File = 'Base.Widget/configs/gizmo.yml'; Content = 'limit: 5'; Expected = "*ships no config 'gizmo' to merge onto*" }
        @{ Case = 'an asset the module does not ship'; File = 'Base.Widget/assets/gizmo.txt'; Content = 'new'; Expected = '*ships no asset assets/gizmo.txt to replace*' }
    ) {
        Set-OverlayFile $File $Content
        { Assert-Overlay } | Should -Throw -ExpectedMessage $Expected
    }

    It 'rejects an override that breaks the contract: <Case>' -ForEach @(
        @{ Case = 'a dropped parameter'; Params = "[Parameter(Mandatory)]`n        [string] `$Name"; Output = '[OutputType([string])]'; Expected = '*drops parameter -Count of Get-Widget*' }
        @{ Case = 'a changed type'; Params = "[Parameter(Mandatory)]`n        [string] `$Name,`n        [string] `$Count"; Output = '[OutputType([string])]'; Expected = '*declares -Count as `[System.String`], but Get-Widget declares `[System.Int32`]*' }
        @{ Case = 'a new mandatory parameter'; Params = "[Parameter(Mandatory)]`n        [string] `$Name,`n        [int] `$Count,`n        [Parameter(Mandatory)]`n        [string] `$Gadget"; Output = '[OutputType([string])]'; Expected = '*makes -Gadget mandatory*' }
        @{ Case = 'another output type'; Params = "[Parameter(Mandatory)]`n        [string] `$Name,`n        [int] `$Count"; Output = '[OutputType([int])]'; Expected = '*declares `[OutputType(System.Int32)`], but Get-Widget declares `[OutputType(System.String)`]*' }
    ) {
        Set-OverlayFile 'Base.Widget/Get-Widget.ps1' "function Get-Widget {`n    $Output`n    param(`n        $Params`n    )`n    'overridden'`n}"
        { Assert-Overlay } | Should -Throw -ExpectedMessage $Expected
    }

    Context 'the consumer''s own modules' -Tag 'ADR-AUTO-CONSUMER-OWNTRACKS', 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
        BeforeAll {
            function script:New-ConsumerTrack {
                param([string] $Name, [string] $Namespace)
                [Catzc.Base.Variants.VariantTrack]::new($Name, [Catzc.Base.Variants.VariantMember[]]@([Catzc.Base.Variants.VariantMember]::new($Name)),
                    'modules', $null, [string[]]@('powershell'), [string[]]@('pwsh'), $null, $null, $Namespace)
            }
        }

        BeforeEach {
            $script:consumerRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            [System.IO.Directory]::CreateDirectory((Join-Path $consumerRoot 'widget/Local/private')) | Out-Null
            Set-Content -Path (Join-Path $consumerRoot 'widget/Local/Get-Local.ps1') -Value 'function Get-Local { }'
            $script:tracks = @(New-ConsumerTrack -Name widget -Namespace Widget)
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Overlay -MockWith { 'build' }
            Mock Get-RepositoryRoot -ModuleName Catzc.Base.Overlay -MockWith { $consumerRoot }
            Mock Get-Track -ModuleName Catzc.Base.Overlay -MockWith { $tracks }
            Mock Get-Config -ModuleName Catzc.Base.Overlay -ParameterFilter { $Config -eq 'module-types' } -MockWith {
                [pscustomobject]@{ types = @([pscustomobject]@{ places = @([pscustomobject]@{ name = 'folder'; except = @('tests') }) }) }
            }
        }

        It 'passes a clean consumer, with a types/ folder' {
            [System.IO.Directory]::CreateDirectory((Join-Path $consumerRoot 'widget/Local/types')) | Out-Null
            Set-Content -Path (Join-Path $consumerRoot 'widget/Local/types/Lever.cs') -Value 'namespace Widget.Local; public sealed class Lever { }'
            Set-Content -Path (Join-Path $consumerRoot 'widget/Local/private/Get-LocalCore.ps1') -Value 'function Get-LocalCore { }'
            { Assert-Overlay -Entry @() } | Should -Not -Throw
        }

        It 'rejects a track in the Catzc namespace' {
            $script:tracks = @(New-ConsumerTrack -Name widget -Namespace Catzc)
            { Assert-Overlay -Entry @() } | Should -Throw -ExpectedMessage "*track 'widget': the namespace 'Catzc' is the system's*"
        }

        It 'rejects a public function that shadows a command the bundle exports' {
            Set-Content -Path (Join-Path $consumerRoot 'widget/Local/Get-Widget.ps1') -Value 'function Get-Widget { }'
            { Assert-Overlay -Entry @() } | Should -Throw -ExpectedMessage '*Widget.Local: public function Get-Widget takes the name of a command already loaded from Catzc.Base.Widget*'
        }

        It 'rejects a registry entry that overrides a sealed catzc config in the Catzc namespace' {
            [System.IO.Directory]::CreateDirectory((Join-Path $consumerRoot 'widget/Local/configs')) | Out-Null
            Set-Content -Path (Join-Path $consumerRoot 'widget/Local/configs/configs.yml') -Value "configs:`n  gadget:`n    type: Catzc.Base.Widget.Gadget"
            { Assert-Overlay -Entry @() } | Should -Throw -ExpectedMessage "*Widget.Local: config 'gadget' is sealed in the Catzc namespace*"
        }

        It 'accepts the same config name registered in the consumer''s own namespace' {
            [System.IO.Directory]::CreateDirectory((Join-Path $consumerRoot 'widget/Local/configs')) | Out-Null
            Set-Content -Path (Join-Path $consumerRoot 'widget/Local/configs/configs.yml') -Value "configs:`n  gadget:`n    type: Widget.Local.Gadget"
            { Assert-Overlay -Entry @() } | Should -Not -Throw
        }

        It 'checks nothing in source mode' {
            Mock Get-CatzcRunMode -ModuleName Catzc.Base.Overlay -MockWith { 'source' }
            $script:tracks = @(New-ConsumerTrack -Name widget -Namespace Catzc)
            { Assert-Overlay -Entry @() } | Should -Not -Throw
        }
    }

    It 'reports every violation in one throw' {
        Set-OverlayFile 'Base.Widget/types/Lever.cs' 'class Lever { }'
        Set-OverlayFile 'Base.Widget/configs/gadget.yml' 'limit: 5'
        $failure = { Assert-Overlay } | Should -Throw -PassThru
        $failure.Exception.Message | Should -BeLike '*breaks 2 rule(s) of ADR-AUTO-OVERLAY*'
        $failure.Exception.Message | Should -BeLike '*not an override point*'
        $failure.Exception.Message | Should -BeLike "*config 'gadget' is sealed*"
    }
}
