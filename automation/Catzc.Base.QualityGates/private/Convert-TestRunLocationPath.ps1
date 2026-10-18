<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Convert-TestRunLocationPath.ps1
    folder: private
    name: convert-test-run-location-path
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
    test: automation/Catzc.Base.QualityGates/tests/Convert-TestRunLocationPath.Tests.ps1
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
