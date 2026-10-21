<#
---
catzc:
  immutable:
    with_body_sha: a56fe468c12f
  edges:
    code: pwsh/Catzc.Base.Docs/types/AdrCitationMap.cs
    cites:
      - ADR-REPO-LINK-ONECITATIONSPELLING
---
#>

# cspell:ignore WDGT  -- the four-letter fixture kind

Describe 'AdrCitationMap' -Tag 'L0', 'logic', 'ADR-REPO-LINK-ONECITATIONSPELLING' {
    BeforeAll {
        $entry = { param($rules) @{ path = 'docs/drs/widget/x.md'; rules = [string[]] $rules } }
        $script:map = [Catzc.Base.Docs.AdrCitationMap]::new([ordered]@{
                'ADR-WIDGET-GADGET'  = (& $entry @('ADR-WIDGET-GADGET-TURN'))
                'GD-SPROCKET-COG'    = (& $entry @('GD-SPROCKET-COG-SPIN'))
                'WDGT-SPROCKET-GEAR' = (& $entry @('WDGT-SPROCKET-GEAR-FOLD'))
            }, @())
    }

    It 'takes every hyphen-prefix after the kind of a <Name> code as a domain code' -ForEach @(
        @{ Name = 'three-letter'; Domain = 'ADR-WIDGET'; Kind = 'ADR' }
        @{ Name = 'two-letter'; Domain = 'GD-SPROCKET'; Kind = 'GD' }
        @{ Name = 'four-letter'; Domain = 'WDGT-SPROCKET'; Kind = 'WDGT' }
    ) {
        $script:map.IsDomainCode($Domain) | Should -BeTrue
        $script:map.IsDomainCode($Kind) | Should -BeFalse
    }
}
