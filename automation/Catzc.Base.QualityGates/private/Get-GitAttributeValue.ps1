<#
.SYNOPSIS
    Reads the given .gitattributes attributes for many repository paths at once.
.DESCRIPTION
    The one place the quality-gate scopes ask git which file classes .gitattributes declares (vendored, generated,
    fixture, own title), so every scope reads the same classes the same way. Runs `git check-attr` in batches that keep
    each command line short; a path need not be tracked. Only attributes git reports as set, unset, or a value are
    returned — `unspecified` is left out. A root that is not a git work tree has no .gitattributes, so nothing is
    returned for it.
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
    for ($index = 0; $index -lt $Path.Count; $index += 100) {
        $batch = $Path[$index..([Math]::Min($index + 99, $Path.Count - 1))]
        $quotedPaths = foreach ($item in $batch) {
            "`"$item`""
        }
        $listing = Invoke-Executable "git -C `"$RepositoryRoot`" -c core.quotepath=off check-attr $($Attribute -join ' ') -- $($quotedPaths -join ' ')" -PassThru -Silent
        foreach ($line in ($listing.Output -split "`r?`n")) {
            if ($line -match '^(?<path>.+): (?<name>[^:]+): (?<value>.+)$' -and $Matches['value'] -ne 'unspecified') {
                if (-not $ret.ContainsKey($Matches['path'])) {
                    $ret[$Matches['path']] = @{}
                }
                $ret[$Matches['path']][$Matches['name']] = $Matches['value']
            }
        }
    }
    $ret
}
