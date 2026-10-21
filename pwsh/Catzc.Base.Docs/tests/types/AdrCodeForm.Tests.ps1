<#
---
catzc:
  immutable:
    with_body_sha: ce9383a561c2
  edges:
    code: pwsh/Catzc.Base.Docs/types/AdrCodeForm.cs
    cites:
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
#>

# cspell:ignore WIDGE  -- the five-letter fixture kind the grammar refuses

Describe 'AdrCodeForm' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    BeforeAll {
        # ADR is shared, GDR owned, and HDR owned with a group segment, as RDR-DORA-<NAME> is.
        $script:form = [Catzc.Base.Docs.AdrCodeForm]::new([ordered]@{ ADR = 3; GDR = 2; HDR = 3 })
        $entry = { param($rules) @{ path = 'docs/drs/widget/x.md'; rules = [string[]] $rules } }
        $script:registry = [Catzc.Base.Docs.AdrCitationMap]::new([ordered]@{
                'ADR-WIDGET-GADGET'   = (& $entry @('ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-FOLD'))
                'ADR-WIDGET-SPROCKET' = (& $entry @('ADR-WIDGET-SPROCKET-RE01', 'ADR-WIDGET-SPROCKET-RE02'))
                'ADR-WIDGET-LONE'     = (& $entry @('ADR-WIDGET-LONE-ONLY'))
            }, @())
    }

    Context 'the grammar' {
        It 'rejects <Name>' -ForEach @(
            @{ Name = 'no kinds'; Kinds = [ordered]@{} }
            @{ Name = 'a lower-case kind'; Kinds = [ordered]@{ adr = 3 } }
            @{ Name = 'a kind of five letters'; Kinds = [ordered]@{ WIDGE = 2 } }
        ) {
            { [Catzc.Base.Docs.AdrCodeForm]::new($Kinds) } | Should -Throw '*record kinds*'
        }

        It 'rejects a rule of no segments' {
            { [Catzc.Base.Docs.AdrCodeForm]::new([ordered]@{ GDR = 0 }) } | Should -Throw '*one or more segments*'
        }

        It 'joins the kinds into one group, in their order' {
            $script:form.Kind | Should -Be '(?:ADR|GDR|HDR)'
        }

        It 'finds a cited code of every kind in text' {
            [regex]::Matches('see ADR-WIDGET-GADGET and GDR-SPROCKET.', $script:form.Cited).Value | Should -Be @('ADR-WIDGET-GADGET', 'GDR-SPROCKET')
        }
    }

    Context 'IsCode' {
        It 'accepts <Name>' -ForEach @(
            @{ Name = 'an ADR code'; Text = 'ADR-WIDGET-GADGET' }
            @{ Name = 'a rule code'; Text = 'ADR-WIDGET-GADGET-TURN' }
            @{ Name = 'a segment with digits, as a vendor id has'; Text = 'ADR-WIDGET-SPROCKET-RE01' }
            @{ Name = 'a domain code'; Text = 'ADR-WIDGET' }
            @{ Name = 'every ADR'; Text = 'ADR' }
            @{ Name = 'a code of an owned kind'; Text = 'GDR-SPROCKET' }
            @{ Name = 'a bare owned kind'; Text = 'GDR' }
        ) {
            $script:form.IsCode($Text) | Should -BeTrue
        }

        It 'rejects <Name>' -ForEach @(
            @{ Name = 'a numbered rule'; Text = 'ADR-WIDGET-GADGET#1' }
            @{ Name = 'the colon spelling'; Text = ('ADR-WIDGET-GADGET' + ':1') }
            @{ Name = 'a group'; Text = 'ADR-WIDGET-GADGET#{1,2}' }
            @{ Name = 'a prefix glob'; Text = 'ADR-WIDGET-*' }
            @{ Name = 'a lower-case code'; Text = 'adr-widget-gadget' }
            @{ Name = 'a segment that starts with a digit'; Text = 'ADR-WIDGET-01' }
            @{ Name = 'an empty segment'; Text = 'ADR--WIDGET' }
            @{ Name = 'a trailing dash'; Text = 'ADR-WIDGET-' }
            @{ Name = 'a trailing newline'; Text = "ADR-WIDGET`n" }
            @{ Name = 'an unregistered kind'; Text = 'CDR-WIDGET-GADGET' }
            @{ Name = 'an empty string'; Text = '' }
            @{ Name = 'null'; Text = $null }
        ) {
            $script:form.IsCode($Text) | Should -BeFalse
        }
    }

    Context 'IsRule' {
        It 'accepts <Name>' -ForEach @(
            @{ Name = 'three segments after a shared kind'; Text = 'ADR-WIDGET-GADGET-TURN' }
            @{ Name = 'two segments after an owned kind'; Text = 'GDR-SPROCKET-TURN' }
            @{ Name = 'three segments after an owned kind with a group segment'; Text = 'HDR-WIDGET-GADGET-TURN' }
        ) {
            $script:form.IsRule($Text) | Should -BeTrue
        }

        It 'rejects <Name>' -ForEach @(
            @{ Name = 'an ADR code of a shared kind'; Text = 'ADR-WIDGET-GADGET' }
            @{ Name = 'an ADR code of an owned kind'; Text = 'GDR-SPROCKET' }
            @{ Name = 'an ADR code under a group segment'; Text = 'HDR-WIDGET-GADGET' }
            @{ Name = 'an unregistered kind'; Text = 'CDR-WIDGET-GADGET-TURN' }
        ) {
            $script:form.IsRule($Text) | Should -BeFalse
        }
    }

    Context 'AnyKind' {
        It 'reads any kind of the shape <Text>' -ForEach @(
            @{ Text = 'CDR-WIDGET-GADGET' }
            @{ Text = 'ADR-WIDGET-GADGET-TURN' }
        ) {
            [Catzc.Base.Docs.AdrCodeForm]::AnyKind.IsRule($Text) | Should -BeTrue
        }

        It 'rejects a kind outside the shape' {
            [Catzc.Base.Docs.AdrCodeForm]::AnyKind.IsCode('WIDGET-GADGET') | Should -BeFalse
        }
    }

    Context 'Covers' {
        It 'covers <Code> from <Prefix>' -ForEach @(
            @{ Prefix = 'ADR'; Code = 'ADR-WIDGET-GADGET-TURN' }
            @{ Prefix = 'ADR-WIDGET'; Code = 'ADR-WIDGET-GADGET' }
            @{ Prefix = 'ADR-WIDGET-GADGET'; Code = 'ADR-WIDGET-GADGET-TURN' }
            @{ Prefix = 'ADR-WIDGET-GADGET'; Code = 'ADR-WIDGET-GADGET' }
        ) {
            [Catzc.Base.Docs.AdrCodeForm]::Covers($Prefix, $Code) | Should -BeTrue
        }

        It 'does not cover <Code> from <Prefix>' -ForEach @(
            @{ Prefix = 'ADR-WIDGET-GAD'; Code = 'ADR-WIDGET-GADGET' }
            @{ Prefix = 'ADR-WIDGET-GADGET-TURN'; Code = 'ADR-WIDGET-GADGET' }
            @{ Prefix = 'ADR-WIDGET-SPROCKET'; Code = 'ADR-WIDGET-GADGET-TURN' }
        ) {
            [Catzc.Base.Docs.AdrCodeForm]::Covers($Prefix, $Code) | Should -BeFalse
        }
    }

    Context 'Minimize' {
        It 'keeps one code as it is' {
            $script:form.Minimize([string[]] @('ADR-WIDGET-GADGET-TURN')) | Should -Be @('ADR-WIDGET-GADGET-TURN')
        }

        It 'collapses duplicates' {
            $script:form.Minimize([string[]] @('ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-GADGET-TURN')) | Should -Be @('ADR-WIDGET-GADGET-TURN')
        }

        It 'lets a code absorb every code it covers, and keeps a domain code' {
            $script:form.Minimize([string[]] @('ADR-WIDGET-GADGET', 'ADR-WIDGET-GADGET-TURN', 'ADR-COG-BOLT-NUT', 'ADR-COG')) |
                Should -Be @('ADR-COG', 'ADR-WIDGET-GADGET')
        }

        It 'lets a code of an owned kind absorb its rules' {
            $script:form.Minimize([string[]] @('GDR-SPROCKET-TURN', 'GDR-SPROCKET')) | Should -Be @('GDR-SPROCKET')
        }

        It 'orders ordinally without a registry' {
            $script:form.Minimize([string[]] @('ADR-WIDGET-GADGET-TURN', 'ADR-COG-BOLT-NUT', 'ADR-WIDGET-GADGET-FOLD')) |
                Should -Be @('ADR-COG-BOLT-NUT', 'ADR-WIDGET-GADGET-FOLD', 'ADR-WIDGET-GADGET-TURN')
        }

        It 'orders rules at their authored place with a registry' {
            $script:form.Minimize([string[]] @('ADR-WIDGET-GADGET-FOLD', 'ADR-WIDGET-GADGET-TURN'), $script:registry) |
                Should -Be @('ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-GADGET-FOLD')
        }

        It 'writes the ADR code when every rule the registry declares is cited' {
            $script:form.Minimize([string[]] @('ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-FOLD', 'ADR-WIDGET-GADGET-TURN'), $script:registry) |
                Should -Be @('ADR-WIDGET-GADGET')
            $script:form.Minimize([string[]] @('ADR-WIDGET-SPROCKET-RE02', 'ADR-WIDGET-SPROCKET-RE01'), $script:registry) |
                Should -Be @('ADR-WIDGET-SPROCKET')
        }

        It 'writes the ADR code for an ADR with a single rule when that rule is cited' {
            $script:form.Minimize([string[]] @('ADR-WIDGET-LONE-ONLY'), $script:registry) | Should -Be @('ADR-WIDGET-LONE')
        }

        It 'keeps the rules when one is missing' {
            $script:form.Minimize([string[]] @('ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-GADGET-FOLD'), $script:registry) |
                Should -Be @('ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-GADGET-FOLD')
        }

        It 'never collapses without a registry, nor a code the registry does not hold' {
            $script:form.Minimize([string[]] @('ADR-WIDGET-LONE-ONLY')) | Should -Be @('ADR-WIDGET-LONE-ONLY')
            $script:form.Minimize([string[]] @('ADR-NOPE-ONE-TWO'), $script:registry) | Should -Be @('ADR-NOPE-ONE-TWO')
        }

        It 'returns nothing for no codes' {
            @($script:form.Minimize([string[]] @())).Count | Should -Be 0
        }

        It 'rejects <Item>' -ForEach @(
            @{ Item = 'ADR-WIDGET-GADGET#1' }
            @{ Item = 'ADR-WIDGET-GADGET#{1,2}' }
            @{ Item = 'ADR-WIDGET-*' }
            @{ Item = 'CDR-WIDGET-GADGET' }
        ) {
            { $script:form.Minimize([string[]] @($Item)) } | Should -Throw
        }

        It 'is idempotent' {
            $first = $script:form.Minimize([string[]] @('ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-LONE-ONLY', 'ADR-COG-BOLT-NUT'), $script:registry)
            $script:form.Minimize([string[]] @($first), $script:registry) | Should -Be $first
        }
    }
}
