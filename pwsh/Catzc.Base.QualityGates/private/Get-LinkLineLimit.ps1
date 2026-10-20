<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1
    folder: private
    name: get-link-line-limit
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-LinkLineLimit.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-LinkLineLimit.ps1.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
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
