<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-contracts/tests/types/ContractManifest.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'ContractManifest' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' {
    It 'is empty for an absent or empty file' {
        [Catzc.Base.Contracts.ContractManifest]::new($null).applies_to.Count | Should -Be 0
        [Catzc.Base.Contracts.ContractManifest]::new(@{}).applies_to.Count | Should -Be 0
    }

    It 'maps the globs applies_to names per asset, keyed by its file name or its group and file name' {
        $manifest = [Catzc.Base.Contracts.ContractManifest]::new(@{ applies_to = [ordered]@{ 'gadgets/flow.yml.schema.json' = @('flows/**/*.yml', 'gadget.yml'); 'widget.md' = @('widget.md') } })
        $manifest.applies_to['gadgets/flow.yml.schema.json'] | Should -Be @('flows/**/*.yml', 'gadget.yml')
        $manifest.applies_to['widget.md'] | Should -Be @('widget.md')
    }

    It 'rejects an unknown key, direction included, which a root now decides' {
        { [Catzc.Base.Contracts.ContractManifest]::new(@{ direction = @{ 'a.md' = 'provided' } }) } |
            Should -Throw "*unknown key 'direction' (allowed: applies_to)*"
    }

    It 'keys an asset in one folder of a group by its path below the version folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        $manifest = [Catzc.Base.Contracts.ContractManifest]::new(@{ applies_to = [ordered]@{ 'gadgets/flows/a.schema.json' = @('a.json') } })
        $manifest.applies_to.Keys | Should -Be @('gadgets/flows/a.schema.json')
    }

    It 'collects every violation: a key two folders below a group, an empty glob list, a rooted glob, and applies_to that is not a map' {
        $raw = @{ applies_to = [ordered]@{ 'a/b/c/d.json' = @('a.yml'); 'gadgets/a.json' = @(); 'gadgets/b.json' = @('/b.yml') } }
        { [Catzc.Base.Contracts.ContractManifest]::new($raw) } |
            Should -Throw "*'a/b/c/d.json' is not an asset's <file>, <group>/<file> or <group>/<folder>/<file>*'gadgets/a.json' must be a non-empty list*'/b.yml' is not a repository-relative*"
        { [Catzc.Base.Contracts.ContractManifest]::new(@{ applies_to = 'a.yml' }) } |
            Should -Throw '*applies_to must be a map*'
    }
}
