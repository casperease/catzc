Describe 'Get-Overlay' -Tag 'L0', 'logic' {
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
        Set-OverlayFile 'Base.Widget/Get-Widget.ps1' 'function Get-Widget { }'
        Set-OverlayFile 'Base.Widget/private/Get-WidgetCore.ps1' 'function Get-WidgetCore { }'
        Set-OverlayFile 'Base.Widget/configs/widget.yml' 'limit: 5'
        Set-OverlayFile 'Base.Widget/assets/sub/lever.txt' 'consumer'
        Set-OverlayFile 'Base.Widget/tests/Get-Widget.Tests.ps1' "Describe 'x' { }"
        Set-OverlayFile 'Base.Widget/README.md' '# no'
        Set-OverlayFile 'Widget.Local/Get-Local.ps1' 'function Get-Local { }'

        $entries = @(Get-Overlay)
        $rows = @($entries | ForEach-Object { '{0}|{1}|{2}|{3}' -f $_.Kind, $_.Module, $_.Target, $_.Visibility })
        $rows | Should -Be @(
            'FunctionOverride|Catzc.Base.Widget|Get-Widget|public'
            'Unknown|Catzc.Base.Widget|README.md|'
            'AssetOverride|Catzc.Base.Widget|assets/sub/lever.txt|'
            'ConfigFragment|Catzc.Base.Widget|widget|'
            'FunctionOverride|Catzc.Base.Widget|Get-WidgetCore|private'
            'LocalTest|Catzc.Base.Widget|tests/Get-Widget.Tests.ps1|'
            'Finding|Widget.Local|Widget.Local|'
        )
        ($entries | Where-Object Kind -EQ 'ConfigFragment').RelativePath |
            Should -Be '.catzc/pwsh/Base.Widget/configs/widget.yml'
        @($entries | Where-Object Module -EQ 'Catzc.Base.Widget' | ForEach-Object Folder | Select-Object -Unique) |
            Should -Be @('Base.Widget') -Because 'a bundled folder never spells the namespace; the record carries both'
    }

    It 'classifies a bare overlay folder by the namespaced folder of a built root' {
        & $useBuiltRoot
        Set-OverlayFile 'Base.Widget/Get-Widget.ps1' 'function Get-Widget { }'
        Set-OverlayFile 'Base.Widget/configs/widget.yml' 'limit: 5'
        Set-OverlayFile 'Widget.Local/Get-Local.ps1' 'function Get-Local { }'

        $rows = @(Get-Overlay | ForEach-Object { '{0}|{1}|{2}' -f $_.Kind, $_.Module, $_.Target })
        $rows | Should -Be @(
            'FunctionOverride|Catzc.Base.Widget|Get-Widget'
            'ConfigFragment|Catzc.Base.Widget|widget'
            'Finding|Widget.Local|Widget.Local'
        )
    }

    It 'gives a folder that names no bundled module a finding that names the consumer''s tracks' -Tag 'ADR-AUTO-OVERLAY-MODULEOVERRIDEENTRIES', 'ADR-AUTO-CONSUMER-OWNTRACKS' {
        & $useBuiltRoot
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.Overlay -MockWith { 'build' }
        Mock Get-Track -ModuleName Catzc.Base.Overlay -ParameterFilter { $Name } -MockWith { [pscustomobject]@{ name = 'pwsh'; namespace = 'Catzc' } }
        Mock Get-Track -ModuleName Catzc.Base.Overlay -MockWith {
            [pscustomobject]@{ name = 'pwsh'; namespace = 'Catzc' }
            [pscustomobject]@{ name = 'widget'; namespace = 'Widget' }
        }
        Set-OverlayFile 'Widget.Local/Get-Local.ps1' 'function Get-Local { }'

        $finding = (Get-Overlay | Select-Object -First 1).Finding
        $finding | Should -BeLike '*.catzc/pwsh/Widget.Local: names no bundled module*overrides of bundled modules only*'
        $finding | Should -BeLike '*its tracks (widget)*'
        $finding | Should -BeLike '*ADR-AUTO-CONSUMER-OWNTRACKS*'
    }

    It 'says a folder that names no bundled module has no consumer tracks to go to when the consumer declares none' -Tag 'ADR-AUTO-CONSUMER-OWNTRACKS' {
        & $useBuiltRoot
        Mock Get-CatzcRunMode -ModuleName Catzc.Base.Overlay -MockWith { 'build' }
        Mock Get-Track -ModuleName Catzc.Base.Overlay -ParameterFilter { $Name } -MockWith { [pscustomobject]@{ name = 'pwsh'; namespace = 'Catzc' } }
        Mock Get-Track -ModuleName Catzc.Base.Overlay -MockWith { [pscustomobject]@{ name = 'pwsh'; namespace = 'Catzc' } }
        Set-OverlayFile 'Widget.Local/Get-Local.ps1' 'function Get-Local { }'

        (Get-Overlay | Select-Object -First 1).Finding | Should -BeLike '*the consumer declares no tracks of its own*'
    }

    It 'carries no finding on a bundled module''s entries' {
        Set-OverlayFile 'Base.Widget/configs/widget.yml' 'limit: 5'
        (Get-Overlay | Select-Object -First 1).Finding | Should -BeNullOrEmpty
    }

    It 'returns nothing when there is no overlay' {
        Mock Get-OverlayRoot -ModuleName Catzc.Base.Overlay -MockWith { }
        @(Get-Overlay) | Should -BeNullOrEmpty
    }
}
