<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/Get-CommandContract.ps1
    name: get-command-contract
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/Get-CommandContract.Tests.ps1
    docs: "[Get-CommandContract.ps1.md](docs/references/pwsh/catzc-base-contracts/Get-CommandContract.ps1.md)"
    cites:
      - ADR-REPO-CMDCONTRACT-COMMANDCONTRACT
      - ADR-REPO-CMDCONTRACT-ONEREADER
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
