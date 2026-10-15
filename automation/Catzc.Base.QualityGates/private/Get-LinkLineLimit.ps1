<#
.SYNOPSIS
    Resolves the per-extension comment line limits the link aligner wraps to.
.DESCRIPTION
    links.yml overrides beat .editorconfig, and an extension in neither is absent, so the caller's default applies.
    [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root whose .editorconfig is read; a missing file yields only the overrides.
.PARAMETER Override
    links.yml's line_limit map (extension -> limit).
.OUTPUTS
    [System.Collections.Generic.Dictionary[string,int]] extension ('.ps1') -> limit.
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
