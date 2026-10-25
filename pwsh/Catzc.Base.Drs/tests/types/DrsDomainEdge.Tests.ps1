<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-drs/tests/types/DrsDomainEdge.Tests.ps1.md"
  header: "generated"
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
