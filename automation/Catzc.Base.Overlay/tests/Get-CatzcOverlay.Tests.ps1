<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Overlay/tests/Get-CatzcOverlay.Tests.ps1
    kind: pester-test
---
#>

Describe 'Get-CatzcOverlay' -Tag 'L0', 'logic' {
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

    It 'classifies every entry by where it sits' {
        Set-OverlayFile 'Catzc.Base.Widget/Get-Widget.ps1' 'function Get-Widget { }'
        Set-OverlayFile 'Catzc.Base.Widget/private/Get-WidgetCore.ps1' 'function Get-WidgetCore { }'
        Set-OverlayFile 'Catzc.Base.Widget/configs/widget.yml' 'limit: 5'
        Set-OverlayFile 'Catzc.Base.Widget/assets/sub/lever.txt' 'consumer'
        Set-OverlayFile 'Catzc.Base.Widget/tests/Get-Widget.Tests.ps1' "Describe 'x' { }"
        Set-OverlayFile 'Catzc.Base.Widget/README.md' '# no'
        Set-OverlayFile 'Widget.Local/Get-Local.ps1' 'function Get-Local { }'

        $entries = @(Get-CatzcOverlay)
        $rows = @($entries | ForEach-Object { '{0}|{1}|{2}|{3}' -f $_.Kind, $_.Module, $_.Target, $_.Visibility })
        $rows | Should -Be @(
            'FunctionOverride|Catzc.Base.Widget|Get-Widget|public'
            'Unknown|Catzc.Base.Widget|README.md|'
            'AssetOverride|Catzc.Base.Widget|assets/sub/lever.txt|'
            'ConfigFragment|Catzc.Base.Widget|widget|'
            'FunctionOverride|Catzc.Base.Widget|Get-WidgetCore|private'
            'LocalTest|Catzc.Base.Widget|tests/Get-Widget.Tests.ps1|'
            'LocalModule|Widget.Local|Widget.Local|'
        )
        ($entries | Where-Object Kind -EQ 'ConfigFragment').RelativePath | Should -Be '.catzc/automation/Catzc.Base.Widget/configs/widget.yml'
    }

    It 'returns nothing when there is no overlay' {
        Mock Get-CatzcOverlayRoot -ModuleName Catzc.Base.Overlay -MockWith { }
        @(Get-CatzcOverlay) | Should -BeNullOrEmpty
    }
}
