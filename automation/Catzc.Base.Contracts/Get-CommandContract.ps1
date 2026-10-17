<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/Get-CommandContract.ps1
    name: get-command-contract
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Contracts/tests/Get-CommandContract.Tests.ps1
    cites:
      - ADR-REPO-CMDCONTRACT#{1,5}
  config:
    synopsis: Reads the command contracts, all of them or by command, module, unit or version, as typed ContractCommand records.
    description: |-
      The one reader of a command contract
      ([ADR-REPO-CMDCONTRACT#5](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract5)): every
      `<Verb-Noun>.command.yml` asset Get-Contract lists
      ([ADR-REPO-CMDCONTRACT#1](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract1)) is parsed by the
      ContractCommand type, the one grammar of the contract language, and comes back with its asset, the command's name,
      its parameters, its output and its one-line signature. The selectors take wildcards and narrow the assets the way
      Get-Contract's do; -Name matches the command. A contract that does not parse throws, naming the asset: this is the
      reader, and Test-Contracts is where a defect is reported as a finding.
    parameters:
      Name: 'The command name(s), Verb-Noun, wildcards allowed. Default: every command.'
      Module: 'The owning module name(s), wildcards allowed. Default: every module.'
      Unit: 'The deployable-unit folder name(s), wildcards allowed. Default: every unit.'
      Version: 'The version folder name(s), wildcards allowed. Default: 0.0.0, each unit''s draft.'
      RepositoryRoot: 'The repository root that holds contracts/. Default: the loaded repository root.'
    outputs: '[Catzc.Base.Contracts.ContractCommand[]] in Get-Contract''s ordinal order of unit, version, module, then path.'
    examples:
      - Get-CommandContract
      - Get-CommandContract -Name Get-FileLanguage
      - (Get-CommandContract -Module Catzc.Base.Languages).signature
---
#>

function Get-CommandContract {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractCommand[]])]
    param(
        [Parameter(Position = 0)]
        [SupportsWildcards()]
        [string[]] $Name = '*',

        [SupportsWildcards()]
        [string[]] $Module = '*',

        [SupportsWildcards()]
        [string[]] $Unit = '*',

        [SupportsWildcards()]
        [string[]] $Version = '0.0.0',

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $suffix = [Catzc.Base.Contracts.ContractCommand]::Suffix
    foreach ($asset in Get-Contract -Unit $Unit -Version $Version -Module $Module -Path "*$suffix" -RepositoryRoot $RepositoryRoot) {
        if ($asset.Kind -ne [Catzc.Base.Contracts.ContractAssetKind]::Command) {
            continue
        }
        $command = [Catzc.Base.Contracts.ContractCommand]::NameOf($asset)
        if (@($Name | Where-Object { $command -like $_ }).Count -eq 0) {
            continue
        }
        try {
            $raw = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $asset.AssetPath
            [Catzc.Base.Contracts.ContractCommand]::new($asset, $raw)
        }
        catch {
            $reason = $_.Exception.InnerException ? $_.Exception.InnerException.Message : $_.Exception.Message
            throw "contract asset '$($asset.AssetPath)': $reason"
        }
    }
}
