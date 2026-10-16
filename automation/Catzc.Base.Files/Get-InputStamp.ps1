<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/Get-InputStamp.ps1
    name: get-input-stamp
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-files/Get-InputStamp.ps1.md
    test: automation/Catzc.Base.Files/tests/Get-InputStamp.Tests.ps1
    cites:
      - ADR-PRIN-ONELIVE
  config:
    synopsis: Fingerprints a set of input files by their paths, lengths and last-write times, without reading their content.
    description: |-
      Returns one SHA-256 hex string over the sorted (path, length, last-write ticks) of every file named by -Path. A
      path may be a file or a folder: a folder contributes every file below it (-Filter narrows by name). A missing path
      contributes a marker of its own, so deleting an input changes the stamp. The stamp reads file metadata only, so it
      costs one enumeration however large the inputs are.

      A touched-but-identical file changes the stamp and costs one redundant rebuild; it never hides a real change, so a
      generator that skips on an equal stamp (Test-InputStamp) can only be too eager to rebuild, never too late. The
      caller passes absolute paths; a path is held as given, so the same inputs reached by another spelling stamp
      differently.
    parameters:
      Path: The input files and folders to fingerprint.
      Filter: A file-name filter applied inside folders (for example `*.md`). Defaults to every file.
      Salt: Extra text folded into the stamp, for an input that is not a file (a setting, a version).
    outputs: '[string] A 64-character lowercase SHA-256 hex string.'
    examples:
      - Get-InputStamp -Path $glossaryPaths, (Resolve-RepoPath 'docs/adr') -Filter '*.md'
---
#>

function Get-InputStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [string] $Filter = '*',

        [string] $Salt = ''
    )

    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in $Path) {
        if ([System.IO.File]::Exists($entry)) {
            $info = [System.IO.FileInfo]::new($entry)
            $lines.Add("$($info.FullName)|$($info.Length)|$($info.LastWriteTimeUtc.Ticks)")
        }
        elseif ([System.IO.Directory]::Exists($entry)) {
            $options = [System.IO.EnumerationOptions]::new()
            $options.RecurseSubdirectories = $true
            foreach ($info in [System.IO.DirectoryInfo]::new($entry).EnumerateFiles($Filter, $options)) {
                $lines.Add("$($info.FullName)|$($info.Length)|$($info.LastWriteTimeUtc.Ticks)")
            }
        }
        else {
            $lines.Add("$entry|missing")
        }
    }

    $sorted = $lines.ToArray()
    [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
    $text = ($sorted -join "`n") + "`n#salt:$Salt"
    $hash = [System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($text))
    [System.Convert]::ToHexString($hash).ToLowerInvariant()
}
