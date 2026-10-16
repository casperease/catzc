<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    adrs:
      - ADR-AUTO-DEFAULT#6
  config:
    synopsis: Resolves the per-extension comment line limits the link aligner wraps to.
    description: |-
      Reads max_line_length from the repository's .editorconfig sections of the form [*.ext] and [*.{a,b}] — the
      source of truth for formatting — then applies links.yml's line_limit overrides on top. An extension neither names
      takes the config's default_line_limit
      ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), which the caller passes to
      the engine separately.
    parameters:
      RepositoryRoot: The repository root whose .editorconfig is read; a missing file yields only the overrides.
      Override: links.yml's line_limit map (extension -> limit).
    outputs: '[System.Collections.Generic.Dictionary[string,int]] extension (''.ps1'') -> limit.'
---
#>

function Get-LinkLineLimit {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, int]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [System.Collections.Generic.IReadOnlyDictionary[string, int]] $Override
    )

    $limits = [System.Collections.Generic.Dictionary[string, int]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $editorConfig = Join-Path $RepositoryRoot '.editorconfig'
    if (Test-Path $editorConfig -PathType Leaf) {
        $extensions = @()
        foreach ($line in [System.IO.File]::ReadAllLines($editorConfig)) {
            if ($line -match '^\s*\[\*\.\{(?<list>[^}]+)\}\]\s*$') {
                $extensions = @($Matches['list'] -split ',' | ForEach-Object { '.' + $_.Trim() })
            }
            elseif ($line -match '^\s*\[\*\.(?<one>[A-Za-z0-9]+)\]\s*$') {
                $extensions = @('.' + $Matches['one'])
            }
            elseif ($line -match '^\s*\[') {
                $extensions = @()
            }
            elseif ($line -match '^\s*max_line_length\s*=\s*(?<limit>\d+)\s*$') {
                foreach ($extension in $extensions) {
                    $limits[$extension] = [int] $Matches['limit']
                }
            }
        }
    }

    if ($Override) {
        foreach ($entry in $Override.GetEnumerator()) {
            $limits[$entry.Key] = $entry.Value
        }
    }
    , $limits
}
