<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractAssetNote.ps1
    folder: private
    name: get-contract-asset-note
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1
    adrs:
      - ADR-REPO-CONTRACT#6
  config:
    synopsis: 'Reads a contract asset''s note: the header comment its file carries, as one line of text.'
    description: |-
      The note is what an asset says about itself, in the one place it can say it without changing what its check
      compares ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)). Build-ContractReference
      lists it per asset. By the asset's format (Get-ContractDataFormat):
      - a YAML asset (a fragment or a sample payload): the leading run of '#' comment lines, which parsing ignores. The
        run ends at the first line that is not a comment, a blank line included;
      - a schema: its top-level "$comment", the JSON Schema comment keyword, which the schema check accepts as a no-op.
        JSON has no comment syntax, so this is the one place a schema carries a note;
      - every other asset carries none, and gives nothing: a presence asset is empty by definition; a text fragment's
        every non-blank line must appear in the real file, so a comment would bind the real file to it; and a JSON
        fragment or sample payload compares every key, so a note key would change what it pins.
      The comment marks and the line breaks are dropped, so the note is one line with single spaces. An asset that does
      not read or parse gives nothing: Test-Contracts reports it, and a note is never the place to fail.
    parameters:
      RepositoryRoot: The repository root the asset is relative to.
      Asset: The contract asset.
    outputs: '[string] The note; nothing when the asset carries none.'
    examples:
      - Get-ContractAssetNote -RepositoryRoot $root -Asset $asset
---
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
