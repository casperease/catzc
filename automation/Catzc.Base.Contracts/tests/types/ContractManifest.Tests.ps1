<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/types/ContractManifest.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-REPO-CONTRACT#7
---
#>

# ContractManifest maps a version folder's contract.yml, the direction overrides of single assets.
# [comment:1](/docs/references/automation/catzc-base-contracts/tests/types/ContractManifest.Tests.ps1.md#comment1)
Describe 'ContractManifest' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#7' {
    It 'is empty for an absent or empty file' {
        [Catzc.Base.Contracts.ContractManifest]::new($null).direction.Count | Should -Be 0
        [Catzc.Base.Contracts.ContractManifest]::new(@{}).direction.Count | Should -Be 0
    }

    It 'maps provided and depended-on per asset path under the version folder' {
        $manifest = [Catzc.Base.Contracts.ContractManifest]::new(@{
                direction = [ordered]@{ 'Catzc.Widget/gadget.sample.json' = 'depended-on'; 'Catzc.Widget/widget.yml' = 'provided' }
            })
        $manifest.direction['Catzc.Widget/gadget.sample.json'] | Should -Be ([Catzc.Base.Contracts.ContractDirection]::DependedOn)
        $manifest.direction['Catzc.Widget/widget.yml'] | Should -Be ([Catzc.Base.Contracts.ContractDirection]::Provided)
    }

    It 'collects every violation into one error' {
        $raw = @{ gadget = 1; direction = [ordered]@{ 'widget.yml' = 'provided'; 'Catzc.Widget/gadget.yml' = 'sideways' } }
        { [Catzc.Base.Contracts.ContractManifest]::new($raw) } |
            Should -Throw "*unknown key 'gadget'*'widget.yml' is not a '/'-separated <module>/<path>*'sideways' (valid: provided, depended-on)*"
    }

    It 'rejects a direction that is not a map' {
        { [Catzc.Base.Contracts.ContractManifest]::new(@{ direction = 'provided' }) } | Should -Throw '*direction must be a map*'
    }
}
