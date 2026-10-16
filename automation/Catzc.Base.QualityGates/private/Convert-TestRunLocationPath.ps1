<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Convert-TestRunLocationPath.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Convert-TestRunLocationPath.Tests.ps1
  config:
    synopsis: Maps paths between a test run's working folder and the root of the location it runs in.
    description: |-
      A snapshot run executes the same repository-relative files under a different root. Paths under the
      working folder (SourceRoot) map to the same relative path under the location's Root, and with -ToSource
      back again — test files going into a run, and the rows' File paths coming home so reports and module
      protection read working-folder paths. A path outside the root (a fixture in a temp folder), an empty
      value, and every path of an in-place location pass through unchanged.
    parameters:
      Location: The location Enter-TestRunLocation returned.
      Path: The paths to map.
      ToSource: Map from the location's Root back to the working folder.
    outputs: '[string] one mapped path per input path, in order.'
---
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
