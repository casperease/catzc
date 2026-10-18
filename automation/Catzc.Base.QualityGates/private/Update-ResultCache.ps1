<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Update-ResultCache.ps1
    folder: private
    name: update-result-cache
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
    cites:
      - ADR-AUTO-CACHE#10
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
