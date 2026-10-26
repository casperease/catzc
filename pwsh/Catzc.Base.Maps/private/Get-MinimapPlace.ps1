<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-maps/private/Get-MinimapPlace.ps1.md"
  header: "generated"
---
#>

function Get-MinimapPlace {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        # The file's repository-relative path.
        [Parameter(Mandatory)]
        [string] $Path,

        # The file's facts (Get-MinimapFact): its track and the module that holds it.
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Facts
    )

    $track = "$($Facts['track'])"
    $module = if ($Facts['module'] -and "$($Facts['module'])" -ne $track) {
        "$($Facts['module'])"
    }
    else {
        '-'
    }
    $segments = (New-Object Catzc.Base.Objects.RepoRelativePath $Path).Relative -split '/'
    $at = if ($module -eq '-') {
        0
    }
    else {
        [array]::IndexOf($segments, $module)
    }
    $folder = if ($at -ge 0 -and $at -lt $segments.Count - 2) {
        $segments[($at + 1)..($segments.Count - 2)] -join '/'
    }
    else {
        '.'
    }
    [string[]] @($track, $module, $folder)
}
