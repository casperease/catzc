<#
---
catzc:
  immutable:
    with_body_sha: "42ec847be125"
  edges:
    docs: "[Update-ResultCache.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Update-ResultCache.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
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
            $Cache[$relative] = "$([System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes($full)))):$Stamp$($Key[$full][2])"
        }
        else {
            $Cache[$relative] = $Key[$full][1]
        }
    }
}
