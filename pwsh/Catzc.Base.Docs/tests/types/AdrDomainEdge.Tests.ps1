<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
    folder: tests/types
    name: adr-domain-edge-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[AdrDomainEdge.Tests.ps1.md](docs/references/pwsh/catzc-base-docs/tests/types/AdrDomainEdge.Tests.ps1.md)"
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
