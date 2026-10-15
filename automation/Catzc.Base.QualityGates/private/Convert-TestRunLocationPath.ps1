<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Convert-TestRunLocationPath.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    Maps paths between a test run's working folder and the root of the location it runs in.
.DESCRIPTION
    A path outside the root and every path of an in-place location pass through unchanged.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Convert-TestRunLocationPath.ps1.md#comment1)
.PARAMETER Location
    The location Enter-TestRunLocation returned.
.PARAMETER Path
    The paths to map.
.PARAMETER ToSource
    Map from the location's Root back to the working folder.
.OUTPUTS
    [string] one mapped path per input path, in order.
#>
function Convert-TestRunLocationPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Location,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]] $Path,

        [switch] $ToSource
    )

    $from, $to = if ($ToSource) {
        $Location.Root, $Location.SourceRoot
    }
    else {
        $Location.SourceRoot, $Location.Root
    }
    $from = $from.TrimEnd('\', '/')
    $to = $to.TrimEnd('\', '/')

    foreach ($item in $Path) {
        $isUnder = $item -and $from -ne $to -and (
            $item.Equals($from, [System.StringComparison]::OrdinalIgnoreCase) -or (
                $item.Length -gt $from.Length -and
                $item.StartsWith($from, [System.StringComparison]::OrdinalIgnoreCase) -and
                $item[$from.Length] -in '\', '/'))
        if ($isUnder) {
            $to + $item.Substring($from.Length)
        }
        else {
            $item
        }
    }
}
