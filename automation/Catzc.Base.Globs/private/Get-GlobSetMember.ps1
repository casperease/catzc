<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
    kind: private-function
    module: Catzc.Base.Globs
    visibility: private
    adrs:
      - ADR-FLOW-CD-GLOBS#4
---
#>

<#
.SYNOPSIS
    The tracked files a globset finally selects — the single source of a set's included members.
.DESCRIPTION
    The hash and the public file list both route through here, so the scoped member list cannot drift between them.
.PARAMETER GlobSet
    The globset instance to resolve (declared or derived).
.PARAMETER TrackedFile
    Passing it in saves one git index read per set when resolving many; omitted, it is fetched for this call.
.EXAMPLE
    Get-GlobSetMember -GlobSet (Get-GlobSet -Name automation)
#>
function Get-GlobSetMember {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Catzc.Base.Globs.GlobSet] $GlobSet,

        [AllowEmptyCollection()]
        [string[]] $TrackedFile
    )

    if (-not $PSBoundParameters.ContainsKey('TrackedFile')) {
        $TrackedFile = [string[]] @(Get-TrackedFile)
    }
    # Ordinal (culture-independent) order, selected in one call (GlobSet.SelectMembers).
    $GlobSet.SelectMembers($TrackedFile)
}
