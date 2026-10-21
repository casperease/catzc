<#
---
catzc:
  immutable:
    with_body_sha: baaf0192bc06
  edges:
    docs: "[DrsDomainEdge.Tests.ps1.md](docs/references/pwsh/catzc-base-drs/tests/types/DrsDomainEdge.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Drs/types/DrsDomainEdge.cs
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
#>

Describe 'DrsDomainEdge' -Tag 'L0', 'logic', 'ADR-BCL-TYPES-NATIVETYPEDMODEL' {
    It 'carries its From and To domains' {
        $edge = [Catzc.Base.Drs.DrsDomainEdge]::new('widget', 'gadget')
        $edge.From | Should -Be 'widget'
        $edge.To | Should -Be 'gadget'
    }

    It 'throws on an empty From domain' {
        { [Catzc.Base.Drs.DrsDomainEdge]::new('', 'gadget') } | Should -Throw "*non-empty 'From'*"
    }

    It 'throws on an empty To domain' {
        { [Catzc.Base.Drs.DrsDomainEdge]::new('widget', ' ') } | Should -Throw "*from 'widget' requires a non-empty 'To'*"
    }

    It 'throws on a self-edge' {
        { [Catzc.Base.Drs.DrsDomainEdge]::new('widget', 'widget') } | Should -Throw "*'widget' cannot depend on itself*"
    }
}
