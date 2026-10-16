<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-docs/tests/types/AdrDomainEdge.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TYPES#9
---
#>

Describe 'AdrDomainEdge' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {
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
