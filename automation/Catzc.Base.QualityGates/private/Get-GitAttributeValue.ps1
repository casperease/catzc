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
    # git.exe takes a 32,767-character command line, so a batch runs to 24,000: each launch costs about 45 ms.
    foreach ($batch in @(Split-CommandLineBatch -Item $Path -MaxLength 24000)) {
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
