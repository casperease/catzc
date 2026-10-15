<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractAssetNote.ps1
    kind: function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#6
---
#>

<#
.SYNOPSIS
    Reads a contract asset's note: the header comment its file carries, as one line of text.
.DESCRIPTION
    Only a YAML comment or a schema's $comment carries a note; any other would change what the check compares.
.PARAMETER RepositoryRoot
    The repository root the asset is relative to.
.PARAMETER Asset
    The contract asset.
.OUTPUTS
    [string] The note; nothing when the asset carries none.
.EXAMPLE
    Get-ContractAssetNote -RepositoryRoot $root -Asset $asset
#>
function Get-ContractAssetNote {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [Catzc.Base.Contracts.ContractAsset] $Asset
    )

    if ($Asset.Kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Presence) {
        return
    }
    $format = Get-ContractDataFormat -Path $Asset.Path
    $parts = [System.Collections.Generic.List[string]]::new()

    if ($format -ceq 'Yaml') {
        foreach ($line in [System.IO.File]::ReadAllLines((Join-Path $RepositoryRoot $Asset.AssetPath))) {
            $comment = [regex]::Match($line, '^\s*#(.*)$')
            if (-not $comment.Success) {
                break
            }
            $parts.Add($comment.Groups[1].Value)
        }
    }
    elseif ($format -ceq 'Json' -and $Asset.Kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Schema) {
        try {
            $schema = Read-ContractData -RepositoryRoot $RepositoryRoot -Path $Asset.AssetPath
        }
        catch {
            Write-Verbose "Get-ContractAssetNote: '$($Asset.AssetPath)' does not parse, so it carries no note: $($_.Exception.Message)"
            return
        }
        if ($schema -is [System.Collections.IDictionary] -and $schema.Contains('$comment') -and $schema['$comment'] -is [string]) {
            $parts.Add($schema['$comment'])
        }
    }

    $note = ($parts -join ' ') -replace '\s+', ' '
    $note = $note.Trim()
    if ($note) {
        $note
    }
}
