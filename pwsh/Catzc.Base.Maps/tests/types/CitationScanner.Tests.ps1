Describe 'CitationScanner' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:index = [Catzc.Base.Maps.CitationScanner]::Index([ordered]@{
                'ADR-WIDGET-GADGET'   = 'widgetry'
                'ADR-WIDGET-GADGET-X' = 'widgetry'
                'ADR-GIZMO-COG'       = 'gizmos'
            })
        $script:scan = { param([string] $Text) @([Catzc.Base.Maps.CitationScanner]::Scan($Text, $script:index)) }
    }

    It 'finds ADR and rule codes as written, distinct, in ordinal order' {
        $text = @(
            'See [ADR-WIDGET-GADGET-TURN](/docs/drs/widgetry/widget-gadget.md#rule-adr-widget-gadget-turn).'
            '### Rule ADR-WIDGET-GADGET-TURN'
            'ADR-GIZMO-COG decides; ADR-WIDGET-GADGET-RE12 too, and `ADR-WIDGET-GADGET`.'
        ) -join "`n"
        & $script:scan $text | Should -Be @('ADR-GIZMO-COG', 'ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGET-RE12',
            'ADR-WIDGET-GADGET-TURN')
    }

    It 'keeps a code whose longest listed prefix is an ADR of its own' {
        & $script:scan 'ADR-WIDGET-GADGET-X-SPIN and ADR-WIDGET-GADGET-X' | Should -Be @('ADR-WIDGET-GADGET-X',
            'ADR-WIDGET-GADGET-X-SPIN')
        [Catzc.Base.Maps.CitationScanner]::CodeOf('ADR-WIDGET-GADGET-X-SPIN', $script:index) |
            Should -Be 'ADR-WIDGET-GADGET-X'
    }

    It 'ignores the decoys' {
        $decoys = @(
            'ADR-WIDGET-UNKNOWN'          # a code no listed ADR is a prefix of
            'theADR-WIDGET-GADGET'        # glued to a letter before
            'ADR-WIDGET-GADGETS'          # glued to a letter after
            'ADR-WIDGET-GADGET_2'         # glued to an underscore
            'ADR-WIDGET-*'                # a wildcard
            'ADR-WIDGET-GADGET-*'         # a wildcard over a known code
            'adr-widget-gadget'           # lowercase
            '#rule-adr-widget-gadget-turn' # a link anchor
            'ADR-GIZMO-COG3'              # a digit glued to the code
        ) -join ' '
        & $script:scan $decoys | Should -BeNullOrEmpty
    }

    It 'reads the code before a numbered rule as the code alone' {
        & $script:scan ('ADR-GIZMO-COG: the cog. ADR-WIDGET-GADGET' + '#3') | Should -Be @('ADR-GIZMO-COG',
            'ADR-WIDGET-GADGET')
    }

    It 'returns nothing for empty text or an empty index' {
        & $script:scan '' | Should -BeNullOrEmpty
        @([Catzc.Base.Maps.CitationScanner]::Scan('ADR-GIZMO-COG', [Catzc.Base.Maps.CitationScanner]::Index(@{}))) |
            Should -BeNullOrEmpty
    }

    It 'maps a citation to its domain through the index' {
        [Catzc.Base.Maps.CitationScanner]::DomainOf('ADR-GIZMO-COG-SPIN', $script:index) | Should -Be 'gizmos'
        [Catzc.Base.Maps.CitationScanner]::DomainOf('ADR-WIDGET-GADGET', $script:index) | Should -Be 'widgetry'
        [Catzc.Base.Maps.CitationScanner]::DomainOf('ADR-WIDGET-UNKNOWN', $script:index) | Should -BeNullOrEmpty
    }

    It 'canonicalises a reference by trimming it and rejects a non-reference' {
        [Catzc.Base.Maps.CitationScanner]::Canonical(' ADR-GIZMO-COG-SPIN ') | Should -Be 'ADR-GIZMO-COG-SPIN'
        [Catzc.Base.Maps.CitationScanner]::Canonical('ADR-GIZMO-COG') | Should -Be 'ADR-GIZMO-COG'
        [Catzc.Base.Maps.CitationScanner]::Canonical('ADR-GIZMO-COG' + '#4') | Should -BeNullOrEmpty
        [Catzc.Base.Maps.CitationScanner]::Canonical('gizmo cog') | Should -BeNullOrEmpty
        [Catzc.Base.Maps.CitationScanner]::CodeOf('ADR-GIZMO-COG-SPIN', $script:index) | Should -Be 'ADR-GIZMO-COG'
    }

    It 'lets a code cover every code below it, either way round, and nothing beside it' {
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-GIZMO-COG', 'ADR-GIZMO-COG-SPIN') | Should -BeTrue
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-GIZMO-COG-SPIN', 'ADR-GIZMO-COG') | Should -BeTrue
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-GIZMO-COG-SPIN', 'ADR-GIZMO-COG-SPIN') | Should -BeTrue
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-GIZMO-COG-SPIN', 'ADR-GIZMO-COG-TURN') | Should -BeFalse
        [Catzc.Base.Maps.CitationScanner]::Covers('ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGETS') | Should -BeFalse
    }

    It 'reads only the file kinds that cite' {
        foreach ($path in 'widget/Get-Widget.ps1', 'widget/types/Widget.cs', 'widget/configs/widget.yml',
            'gadget/ci.yaml', 'docs/widget.MD') {
            [Catzc.Base.Maps.CitationScanner]::Cites($path) | Should -BeTrue -Because $path
        }
        foreach ($path in 'widget/widget.json', 'docs/.assets/widget.png', 'widget/.gitkeep', 'widget/WIDGET') {
            [Catzc.Base.Maps.CitationScanner]::Cites($path) | Should -BeFalse -Because $path
        }
    }

    It 'places each citation on its line, as header help, a passing comment or text' {
        $sites = { param([string] $Path, [string[]] $Lines)
            @([Catzc.Base.Maps.CitationScanner]::Sites($Path, ($Lines -join "`n"),
                $script:index) | ForEach-Object { "$($_.Line) $($_.Kind) $($_.Citation)" })
        }
        & $sites 'widgets/Get-Widget.ps1' @(
            '# ADR-WIDGET-GADGET-TURN'
            'function Get-Widget {'
            '    <#'
            '    .SYNOPSIS'
            '        ADR-GIZMO-COG-SPIN'
            '    #>'
            '    $count = 1 # ADR-WIDGET-GADGET'
            '    # ADR-GIZMO-COG'
            '    ''ADR-WIDGET-GADGET-FOLD'''
            '}'
        ) | Should -Be @('1 help ADR-WIDGET-GADGET-TURN', '5 help ADR-GIZMO-COG-SPIN', '7 comment ADR-WIDGET-GADGET',
            '8 comment ADR-GIZMO-COG',
            '9 text ADR-WIDGET-GADGET-FOLD')
        & $sites 'widgets/types/Widget.cs' @('// ADR-GIZMO-COG', 'class Widget {', '    /// ADR-WIDGET-GADGET',
            '    int cogs; // ADR-GIZMO-COG-LIFT', '}') |
            Should -Be @('1 help ADR-GIZMO-COG', '3 help ADR-WIDGET-GADGET', '4 comment ADR-GIZMO-COG-LIFT')
        & $sites 'widgets/configs/widget.yml' @('# ADR-GIZMO-COG', 'gadget: ADR-WIDGET-GADGET',
            'cogs: 2 # ADR-GIZMO-COG-SPIN') |
            Should -Be @('1 help ADR-GIZMO-COG', '2 text ADR-WIDGET-GADGET', '3 comment ADR-GIZMO-COG-SPIN')
        & $sites 'docs/widget.md' @('# ADR-GIZMO-COG', 'Read ADR-WIDGET-GADGET.') | Should -Be @('1 text ADR-GIZMO-COG',
            '2 text ADR-WIDGET-GADGET')
        & $sites 'docs/widget.md' @('ADR-WIDGET-UNKNOWN') | Should -BeNullOrEmpty
    }

    It 'rejects an index key that is not an ADR code' {
        { [Catzc.Base.Maps.CitationScanner]::Index(@{ 'WIDGET-GADGET' = 'widgetry' }) } |
            Should -Throw "*'WIDGET-GADGET' is not an ADR code*"
        { [Catzc.Base.Maps.CitationScanner]::Index(@{ ('ADR-WIDGET-GADGET' + '#2') = 'widgetry' }) } |
            Should -Throw '*is not an ADR code*'
        { [Catzc.Base.Maps.CitationScanner]::Index(@{ 'ADR-WIDGET-GADGET' = '' }) } | Should -Throw '*names no domain*'
    }
}
