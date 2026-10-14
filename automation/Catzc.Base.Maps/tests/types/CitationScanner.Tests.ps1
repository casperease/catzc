Describe 'CitationScanner' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:index = [Catzc.Base.Maps.CitationScanner]::Index([ordered]@{
                'ADR-WIDGET-GADGET'   = 'widgetry'
                'ADR-WIDGET-GADGET-X' = 'widgetry'
                'ADR-GIZMO-COG'       = 'gizmos'
            })
        $script:scan = { param([string] $Text) @([Catzc.Base.Maps.CitationScanner]::Scan($Text, $script:index)) }
    }

    It 'finds the #n, :n and bare forms, canonical, distinct, in ordinal order' {
        $text = @(
            'See [ADR-WIDGET-GADGET#3](/docs/adr/widgetry/widget-gadget.md#rule-adr-widget-gadget3).'
            '### Rule ADR-WIDGET-GADGET:3'
            'ADR-GIZMO-COG decides; ADR-WIDGET-GADGET#12 too, and `ADR-WIDGET-GADGET`.'
        ) -join "`n"
        & $script:scan $text | Should -Be @('ADR-GIZMO-COG', 'ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGET#12', 'ADR-WIDGET-GADGET#3')
    }

    It 'takes the longest code the text spells' {
        & $script:scan 'ADR-WIDGET-GADGET-X#2 and ADR-WIDGET-GADGET-X' | Should -Be @('ADR-WIDGET-GADGET-X', 'ADR-WIDGET-GADGET-X#2')
    }

    It 'ignores the decoys' {
        $decoys = @(
            'ADR-WIDGET-UNKNOWN'          # a code the index does not list
            'theADR-WIDGET-GADGET'        # glued to a letter before
            'ADR-WIDGET-GADGETS'          # glued to a letter after
            'ADR-WIDGET-GADGET_2'         # glued to an underscore
            'ADR-WIDGET-*'                # a wildcard
            'ADR-WIDGET-GADGET-*'         # a wildcard over a known code
            'adr-widget-gadget'           # lowercase
            '#rule-adr-widget-gadget3'    # a link anchor
            'ADR-GIZMO-COG3'              # a digit glued to the code
        ) -join ' '
        & $script:scan $decoys | Should -BeNullOrEmpty
    }

    It 'reads a rule separator without a number as a bare citation' {
        & $script:scan 'ADR-GIZMO-COG: the cog. ADR-WIDGET-GADGET#' | Should -Be @('ADR-GIZMO-COG', 'ADR-WIDGET-GADGET')
    }

    It 'returns nothing for empty text or an empty index' {
        & $script:scan '' | Should -BeNullOrEmpty
        @([Catzc.Base.Maps.CitationScanner]::Scan('ADR-GIZMO-COG', [Catzc.Base.Maps.CitationScanner]::Index(@{}))) | Should -BeNullOrEmpty
    }

    It 'maps a citation to its domain through the index' {
        [Catzc.Base.Maps.CitationScanner]::DomainOf('ADR-GIZMO-COG#4', $script:index) | Should -Be 'gizmos'
        [Catzc.Base.Maps.CitationScanner]::DomainOf('ADR-WIDGET-GADGET', $script:index) | Should -Be 'widgetry'
        [Catzc.Base.Maps.CitationScanner]::DomainOf('ADR-WIDGET-UNKNOWN', $script:index) | Should -BeNullOrEmpty
    }

    It 'canonicalises a reference in any form and rejects a non-reference' {
        [Catzc.Base.Maps.CitationScanner]::Canonical('ADR-GIZMO-COG:4') | Should -Be 'ADR-GIZMO-COG#4'
        [Catzc.Base.Maps.CitationScanner]::Canonical(' ADR-GIZMO-COG#4 ') | Should -Be 'ADR-GIZMO-COG#4'
        [Catzc.Base.Maps.CitationScanner]::Canonical('ADR-GIZMO-COG') | Should -Be 'ADR-GIZMO-COG'
        [Catzc.Base.Maps.CitationScanner]::Canonical('gizmo cog') | Should -BeNullOrEmpty
        [Catzc.Base.Maps.CitationScanner]::CodeOf('ADR-GIZMO-COG#4') | Should -Be 'ADR-GIZMO-COG'
    }

    It 'lets a bare request cover every rule, and a rule request only its rule and the bare form' {
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-GIZMO-COG', 'ADR-GIZMO-COG#4') | Should -BeTrue
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-GIZMO-COG#4', 'ADR-GIZMO-COG') | Should -BeTrue
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-GIZMO-COG#4', 'ADR-GIZMO-COG#4') | Should -BeTrue
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-GIZMO-COG#4', 'ADR-GIZMO-COG#5') | Should -BeFalse
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGET-X') | Should -BeFalse
    }

    It 'reads only the file kinds that cite' {
        foreach ($path in 'widget/Get-Widget.ps1', 'widget/types/Widget.cs', 'widget/configs/widget.yml', 'gadget/ci.yaml', 'docs/widget.MD') {
            [Catzc.Base.Maps.CitationScanner]::Cites($path) | Should -BeTrue -Because $path
        }
        foreach ($path in 'widget/widget.json', 'docs/.assets/widget.png', 'widget/.gitkeep', 'widget/WIDGET') {
            [Catzc.Base.Maps.CitationScanner]::Cites($path) | Should -BeFalse -Because $path
        }
    }

    It 'rejects an index key that is not an ADR code' {
        { [Catzc.Base.Maps.CitationScanner]::Index(@{ 'WIDGET-GADGET' = 'widgetry' }) } | Should -Throw "*'WIDGET-GADGET' is not an ADR code*"
        { [Catzc.Base.Maps.CitationScanner]::Index(@{ 'ADR-WIDGET-GADGET#2' = 'widgetry' }) } | Should -Throw '*is not an ADR code*'
        { [Catzc.Base.Maps.CitationScanner]::Index(@{ 'ADR-WIDGET-GADGET' = '' }) } | Should -Throw '*names no domain*'
    }
}
