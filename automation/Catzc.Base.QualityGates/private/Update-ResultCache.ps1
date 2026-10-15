<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Update-ResultCache.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-CACHE#10
---
#>

<#
.SYNOPSIS
    Records a quality check's verdicts in its result cache: the checked files it found clean, and no others.
.DESCRIPTION
    A flagged file loses its entry so it is rechecked every run; -RekeyFromDisk rekeys after an in-place rewrite.
.PARAMETER Cache
    The result cache, updated in place.
.PARAMETER Key
    The Key map Split-CachedFile returned.
.PARAMETER Checked
    The files the check ran on.
.PARAMETER Flagged
    The checked files the check would change or reported a finding for.
.PARAMETER Stamp
    The check's input stamp; needed with -RekeyFromDisk.
.PARAMETER RekeyFromDisk
    Recompute each clean file's key from its current bytes.
#>
function Update-ResultCache {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Cache,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Key,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Checked,

        [AllowEmptyCollection()]
        [string[]] $Flagged = @(),

        [string] $Stamp,

        [switch] $RekeyFromDisk
    )

    $flaggedSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($path in $Flagged) {
        [void] $flaggedSet.Add([System.IO.Path]::GetFullPath($path))
    }
    foreach ($path in $Checked) {
        $full = [System.IO.Path]::GetFullPath($path)
        if (-not $Key.Contains($full)) {
            continue
        }
        $relative = $Key[$full][0]
        if ($flaggedSet.Contains($full) -or -not [System.IO.File]::Exists($full)) {
            $Cache.Remove($relative)
        }
        elseif ($RekeyFromDisk) {
            $Cache[$relative] = "$([System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($full)))):$Stamp"
        }
        else {
            $Cache[$relative] = $Key[$full][1]
        }
    }
}
