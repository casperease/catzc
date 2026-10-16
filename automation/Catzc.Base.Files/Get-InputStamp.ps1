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
    synopsis: Fingerprints a set of input files by their paths and content, the same on every checkout of the same inputs.
    description: |-
      Returns one SHA-256 hex string over the sorted (path, content hash) of every file named by -Path. A path may be a
      file or a folder: a folder contributes every file below it (-Filter narrows by name). A missing path contributes a
      marker of its own, so deleting an input changes the stamp.

      The stamp depends on what the inputs say, never on when they were written: a path under -Root is named relative to
      it with '/' separators, and a file's content is hashed with its carriage returns removed. A clone, a snapshot, a
      CRLF checkout and a touched-but-identical file all stamp the same, so a generator can write the stamp into the file
      it generates and every checkout agrees with it (Test-GeneratedFileCurrent). The cost is one read and hash of each
      input; a few megabytes of text take milliseconds.
    parameters:
      Path: The input files and folders to fingerprint.
      Root: 'The folder paths are named relative to. Default: the repository root. A path outside it is named in full.'
      Filter: A file-name filter applied inside folders (for example `*.md`). Defaults to every file.
      Exclude: 'Wildcard patterns for files left out of the stamp, matched against the full path with ''/'' separators (for example `*/README.md`). A generator names its own output, and the generated pages beside its inputs, so writing them does not change the stamp.'
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

        [string[]] $Exclude = @(),

        [string] $Root = (Get-RepositoryRoot),

        [string] $Salt = ''
    )

    $rootFull = [System.IO.Path]::GetFullPath($Root).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar

    # A generator's own output, and every generated page beside its inputs, is left out by pattern: a write of it must not change the stamp it was built under.
    $skip = [System.Management.Automation.WildcardPattern[]] @($Exclude | ForEach-Object {
            [System.Management.Automation.WildcardPattern]::new(($_ -replace '\\', '/'), [System.Management.Automation.WildcardOptions]::IgnoreCase)
        })

    $files = [System.Collections.Generic.List[string]]::new()
    $missing = [System.Collections.Generic.List[string]]::new()
    $options = [System.IO.EnumerationOptions]::new()
    $options.RecurseSubdirectories = $true
    foreach ($entry in $Path) {
        $full = [System.IO.Path]::GetFullPath($entry)
        if ([System.IO.File]::Exists($full)) {
            $files.Add($full)
        }
        elseif ([System.IO.Directory]::Exists($full)) {
            foreach ($file in [System.IO.Directory]::EnumerateFiles($full, $Filter, $options)) {
                $files.Add($file)
            }
        }
        else {
            $missing.Add($full)
        }
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $utf8 = [System.Text.Encoding]::UTF8
    foreach ($file in $files) {
        $slashed = $file.Replace('\', '/')
        $isSkipped = $false
        foreach ($pattern in $skip) {
            if ($pattern.IsMatch($slashed)) {
                $isSkipped = $true
                break
            }
        }
        if ($isSkipped) {
            continue
        }
        $relative = if ($file.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
            $slashed.Substring($rootFull.Length)
        }
        else {
            $slashed
        }
        $content = [System.IO.File]::ReadAllText($file).Replace("`r", '')
        $lines.Add($relative + '|' + [System.Convert]::ToHexString($sha.ComputeHash($utf8.GetBytes($content))))
    }
    foreach ($file in $missing) {
        $slashed = $file.Replace('\', '/')
        $lines.Add(($(if ($file.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) { $slashed.Substring($rootFull.Length) } else { $slashed })) + '|missing')
    }

    $sorted = $lines.ToArray()
    [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
    $text = ($sorted -join "`n") + "`n#salt:$Salt"
    [System.Convert]::ToHexString($sha.ComputeHash($utf8.GetBytes($text))).ToLowerInvariant()
}
