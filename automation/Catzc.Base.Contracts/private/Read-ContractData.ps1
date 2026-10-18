<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/private/Read-ContractData.ps1
    folder: private
    name: read-contract-data
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-contracts/private/Read-ContractData.ps1.md
    cites:
      - ADR-REPO-CONTRACT#6
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
            $data = $text | ConvertFrom-Json -AsHashtable -NoEnumerate -Depth 100
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
