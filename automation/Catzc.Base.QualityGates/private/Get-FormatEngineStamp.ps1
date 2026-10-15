<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FormatEngineStamp.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-CACHE#10
---
#>

<#
.SYNOPSIS
    The fingerprint of everything besides a file's own bytes that decides what a formatter engine writes.
.DESCRIPTION
    A `<file>#<key>` entry stamps one key's value, so another tool's pin edit leaves this engine's cache warm.
    [ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-FormatEngineStamp.ps1.md#comment1)
.PARAMETER Engine
    The engine name, as languages.yml spells it.
.PARAMETER Settings
    The engine's settings entries, repository-relative: a file, or `<file>#<key>` for one top-level key of a YAML file.
.PARAMETER RepositoryRoot
    The repository root.
.OUTPUTS
    [string] A hex SHA-256.
#>
function Get-FormatEngineStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Engine,

        [AllowEmptyCollection()]
        [string[]] $Settings = @(),

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $files = [System.Collections.Generic.List[string]]::new()
    $keyed = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in $Settings) {
        $hash = $entry.IndexOf('#')
        if ($hash -lt 0) {
            $files.Add((Join-Path $RepositoryRoot $entry))
            continue
        }
        $relative = $entry.Substring(0, $hash)
        $key = $entry.Substring($hash + 1)
        $path = Join-Path $RepositoryRoot $relative
        # A missing file or key hashes as missing, so adding or removing the input changes the stamp like any other input.
        $value = 'missing'
        if ([System.IO.File]::Exists($path)) {
            $document = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($path)) -Ordered
            if ($document -is [System.Collections.IDictionary] -and $document.Contains($key)) {
                $value = ConvertTo-Json -InputObject $document[$key] -Depth 32 -Compress
            }
        }
        $valueHash = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($value)))
        $keyed.Add("${relative}#${key}:$valueHash")
    }

    $stamp = Get-ContentStamp -Label "format:$Engine" -File $files.ToArray() -RepositoryRoot $RepositoryRoot
    if ($keyed.Count -eq 0) {
        return $stamp
    }
    $parts = @($stamp) + $keyed.ToArray()
    [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($parts -join "`n")))
}
