<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-GitAttributeValue.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Reads the given .gitattributes attributes for many repository paths at once.
.DESCRIPTION
    Every scope reads the gitattributes classes through here, so they all read the same classes the same way.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-GitAttributeValue.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the paths are relative to.
.PARAMETER Path
    Repository-relative, '/'-separated paths.
.PARAMETER Attribute
    The attribute names to read.
.OUTPUTS
    [hashtable] path -> @{ <attribute> = 'set' | 'unset' | <value> }, for the paths with any attribute specified.
#>
function Get-GitAttributeValue {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [string[]] $Attribute
    )

    $ret = @{}
    # Outside a git work tree (a test's scratch root) no .gitattributes applies, so nothing is specified.
    if (-not (Test-Path -LiteralPath (Join-Path $RepositoryRoot '.git'))) {
        return $ret
    }
    if ($Path.Count -eq 0) {
        return $ret
    }
    # One git process reads every path from stdin, NUL-separated both ways: a process per batch costs about 25 ms each, and no path is quoted or split.
    $listing = Invoke-Executable "git -C `"$RepositoryRoot`" -c core.quotepath=off check-attr -z --stdin $($Attribute -join ' ')" -InputText (($Path -join "`0") + "`0") -PassThru -Silent
    $fields = $listing.Output -split "`0"
    for ($position = 0; $position + 2 -lt $fields.Count; $position += 3) {
        $itemPath = $fields[$position]
        $value = $fields[$position + 2]
        if ($value -ne 'unspecified') {
            if (-not $ret.ContainsKey($itemPath)) {
                $ret[$itemPath] = @{}
            }
            $ret[$itemPath][$fields[$position + 1]] = $value
        }
    }
    $ret
}
