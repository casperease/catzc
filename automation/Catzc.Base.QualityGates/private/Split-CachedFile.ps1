<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Split-CachedFile.ps1
    folder: private
    name: split-cached-file
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
    test: automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1
    cites:
      - ADR-AUTO-CACHE#10
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
