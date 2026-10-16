<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Split-CachedFile.ps1
    folder: private
    name: split-cached-file
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1
    adrs:
      - ADR-AUTO-CACHE#10
  config:
    synopsis: Splits a quality check's files into those its result cache already knows are clean and those to check.
    description: |-
      The read half of a result cache ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)): each
      file inside the repository gets the key '<SHA-256 of its bytes>:<stamp>'; a file whose cache entry equals its key is
      cached, every other file is pending. A file outside the repository, or one that does not exist, is always pending
      and never keyed (it is never recorded). Update-ResultCache is the write half.
    parameters:
      File: The check's files.
      Cache: The result cache (Get-ResultCache).
      Stamp: The check's input stamp (Get-ContentStamp).
      RepositoryRoot: The repository root.
    outputs: '[pscustomobject] { Pending = string[] in the given order; CachedCount; Key = full path -> @(relative path, key) }.'
---
#>

function Split-CachedFile {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Cache,

        [Parameter(Mandatory)]
        [string] $Stamp,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $pending = [System.Collections.Generic.List[string]]::new()
    $keys = @{}
    $cached = 0
    foreach ($path in $File) {
        $full = [System.IO.Path]::GetFullPath($path)
        $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
        if ($relative -eq '..' -or $relative.StartsWith('../') -or -not [System.IO.File]::Exists($full)) {
            $pending.Add($path)
            continue
        }
        $key = "$([System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($full)))):$Stamp"
        $keys[$full] = @($relative, $key)
        if ($Cache.Contains($relative) -and $Cache[$relative] -eq $key) {
            $cached++
        }
        else {
            $pending.Add($path)
        }
    }
    [pscustomobject]@{
        Pending     = [string[]] $pending.ToArray()
        CachedCount = $cached
        Key         = $keys
    }
}
