<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-contracts/tests/types/ContractManifest.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'ContractManifest' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' {
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

    It 'maps the globs applies_to names per asset path, and has none by default' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' {
        [Catzc.Base.Contracts.ContractManifest]::new($null).applies_to.Count | Should -Be 0
        $manifest = [Catzc.Base.Contracts.ContractManifest]::new(@{ applies_to = @{ 'Catzc.Widget/flow.yml.schema.json' = @('flows/**/*.yml', 'gadget.yml') } })
        $manifest.applies_to['Catzc.Widget/flow.yml.schema.json'] | Should -Be @('flows/**/*.yml', 'gadget.yml')
    }

    It 'rejects an applies_to key that names no module and path, an empty glob list, and a rooted glob' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' {
        $raw = @{ applies_to = [ordered]@{ 'flow.yml.schema.json' = @('a.yml'); 'Catzc.Widget/a.json' = @(); 'Catzc.Widget/b.json' = @('/b.yml') } }
        { [Catzc.Base.Contracts.ContractManifest]::new($raw) } |
            Should -Throw "*'flow.yml.schema.json' is not a '/'-separated <module>/<path>*'Catzc.Widget/a.json' must be a non-empty list*'/b.yml' is not a relative*"
    }
}
