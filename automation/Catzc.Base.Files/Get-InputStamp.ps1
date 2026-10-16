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
      Exclude: Files left out of the stamp, by path. A generator names its own output when that sits inside an input folder.
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
    $name = {
        param([string] $FullPath)
        if ($FullPath.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
            $FullPath.Substring($rootFull.Length) -replace '\\', '/'
        }
        else {
            $FullPath -replace '\\', '/'
        }
    }
    $hashOf = {
        param([string] $FullPath)
        $text = [System.IO.File]::ReadAllText($FullPath).Replace("`r", '')
        [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($text))).ToLowerInvariant()
    }

    # A generator's own output often sits inside an input folder; leaving it out keeps its write from changing the stamp it was built under.
    $excluded = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $Exclude) {
        [void] $excluded.Add([System.IO.Path]::GetFullPath($entry))
    }
    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in $Path) {
        if ([System.IO.File]::Exists($entry)) {
            $full = [System.IO.Path]::GetFullPath($entry)
            if (-not $excluded.Contains($full)) {
                $lines.Add("$(& $name $full)|$(& $hashOf $full)")
            }
        }
        elseif ([System.IO.Directory]::Exists($entry)) {
            $options = [System.IO.EnumerationOptions]::new()
            $options.RecurseSubdirectories = $true
            foreach ($info in [System.IO.DirectoryInfo]::new($entry).EnumerateFiles($Filter, $options)) {
                if (-not $excluded.Contains($info.FullName)) {
                    $lines.Add("$(& $name $info.FullName)|$(& $hashOf $info.FullName)")
                }
            }
        }
        else {
            $lines.Add("$(& $name ([System.IO.Path]::GetFullPath($entry)))|missing")
        }
    }

    $sorted = $lines.ToArray()
    [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
    $text = ($sorted -join "`n") + "`n#salt:$Salt"
    $hash = [System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($text))
    [System.Convert]::ToHexString($hash).ToLowerInvariant()
}
