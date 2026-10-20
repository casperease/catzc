<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/tests/types/ContractManifest.Tests.ps1
    folder: tests/types
    name: contract-manifest-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[ContractManifest.Tests.ps1.md](docs/references/pwsh/catzc-base-contracts/tests/types/ContractManifest.Tests.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION
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
}
