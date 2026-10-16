<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-FormatEngineStamp.ps1
    folder: private
    name: get-format-engine-stamp
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-FormatEngineStamp.Tests.ps1
    cites:
      - ADR-AUTO-CACHE#10
  config:
    synopsis: The fingerprint of everything besides a file's own bytes that decides what a formatter engine writes.
    description: |-
      Format-Code's result cache keys a file on its SHA-256 and this stamp (Get-ContentStamp): the engine's name and each
      settings entry languages.yml lists for the engine. An entry is a whole file, or `<file>#<key>` for one top-level key
      of a YAML file; the tool registry is listed by the keys of the tools the engine runs, so that tool's new pin is a new
      stamp and another tool's pin edit is not
      ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). A missing file or key hashes as
      missing, so adding or removing an input changes the stamp. No input is known here that languages.yml does not
      declare.
    parameters:
      Engine: The engine name, as languages.yml spells it.
      Settings: 'The engine''s settings entries, repository-relative: a file, or `<file>#<key>` for one top-level key of a YAML file.'
      RepositoryRoot: The repository root.
    outputs: '[string] A hex SHA-256.'
---
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
