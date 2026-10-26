<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Read-ContractData.ps1.md"
  header: "generated"
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
    # Unenumerated, a top-level array goes out whole; Write-Output -NoEnumerate would wrap it in a list.
    $PSCmdlet.WriteObject($data, $false)
}
