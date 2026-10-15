<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Read-ContractData.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: private
---
#>

<#
.SYNOPSIS
    Reads and parses a JSON or YAML file for a contract check, throwing a finding-ready message when it cannot.
.DESCRIPTION
    An array is returned whole, never enumerated; a file of another format, or one that does not parse, throws its name.
    [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Read-ContractData.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the path is relative to.
.PARAMETER Path
    The file, repository-relative and '/'-separated.
.OUTPUTS
    [object] The parsed document.
.EXAMPLE
    $gadget = Read-ContractData -RepositoryRoot $root -Path '.widget/gadget.yml'
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
    # WriteObject, not Write-Output -NoEnumerate: that would wrap the whole document in a list.
    # [comment:2](/docs/references/automation/catzc-base-contracts/private/Read-ContractData.ps1.md#comment2)
    $PSCmdlet.WriteObject($data, $false)
}
