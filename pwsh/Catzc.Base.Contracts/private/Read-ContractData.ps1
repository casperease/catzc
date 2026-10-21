<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/Read-ContractData.ps1
    folder: private
    name: read-contract-data
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Read-ContractData.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Read-ContractData.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-CONTRACTASSET
---
#>

function Read-ContractData {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $format = Get-ContractDataFormat -Path $Path
    if (-not $format) {
        throw "'$Path' is neither JSON nor YAML (.json, .yml, .yaml), so it cannot be parsed."
    }
    $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $Path))
    try {
        if ($format -ceq 'Json') {
            $data = $text | ConvertFrom-Json -AsHashtable -NoEnumerate -Depth 100 -DateKind String
        }
        else {
            $data = $text | ConvertFrom-Yaml -Ordered
        }
    }
    catch {
        throw "'$Path' does not parse as ${format}: $($_.Exception.Message)"
    }
    $PSCmdlet.WriteObject($data, $false)
}
