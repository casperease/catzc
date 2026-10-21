<#
---
catzc:
  immutable:
    with_body_sha: "68f8f7e501e7"
  edges:
    docs: "[AdrDomainEdge.Tests.ps1.md](docs/references/pwsh/catzc-base-docs/tests/types/AdrDomainEdge.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Docs/types/AdrDomainEdge.cs
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
#>

Describe 'AdrDomainEdge' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    It 'carries its From and To domains' {
        $edge = [Catzc.Base.Docs.AdrDomainEdge]::new('widget', 'gadget')
        $edge.From | Should -Be 'widget'
        $edge.To | Should -Be 'gadget'
    }

    It 'throws on an empty From domain' {
        { [Catzc.Base.Docs.AdrDomainEdge]::new('', 'gadget') } | Should -Throw "*non-empty 'From'*"
    }

    It 'throws on an empty To domain' {
        { [Catzc.Base.Docs.AdrDomainEdge]::new('widget', ' ') } | Should -Throw "*from 'widget' requires a non-empty 'To'*"
    }

    It 'throws on a self-edge' {
        { [Catzc.Base.Docs.AdrDomainEdge]::new('widget', 'widget') } | Should -Throw "*'widget' cannot depend on itself*"
    }
}
