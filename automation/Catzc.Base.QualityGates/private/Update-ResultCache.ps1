<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Update-ResultCache.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-CACHE#10
  config:
    synopsis: 'Records a quality check''s verdicts in its result cache: the checked files it found clean, and no others.'
    description: |-
      The write half of a result cache ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)): each
      checked file that Split-CachedFile keyed is recorded under its key when it is clean, and its entry is removed when
      the check flagged it, so a flagged file is checked again every run until it is fixed. Unkeyed files (outside the
      repository) are skipped. Without -RekeyFromDisk the key is the one computed before the check; with it, the key is
      recomputed from the file's bytes now — for a check that rewrote the file (a formatter writing in place).
    parameters:
      Cache: The result cache, updated in place.
      Key: The Key map Split-CachedFile returned.
      Checked: The files the check ran on.
      Flagged: The checked files the check would change or reported a finding for.
      Stamp: The check's input stamp; needed with -RekeyFromDisk.
      RekeyFromDisk: Recompute each clean file's key from its current bytes.
---
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
