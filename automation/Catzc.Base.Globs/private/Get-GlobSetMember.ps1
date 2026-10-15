<#
.SYNOPSIS
    The tracked files a globset finally selects — the single source of a set's included members.
.DESCRIPTION
    The one definition of "what is IN the package": the matching universe (`git ls-files`) intersected with the set's...
    [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)
    [comment:1](/docs/references/automation/catzc-base-globs/private/Get-GlobSetMember.ps1.md#comment1)
.PARAMETER GlobSet
    The globset instance to resolve (declared or derived).
.PARAMETER TrackedFile
    The tracked-file universe (Get-TrackedFile), fetched once by a caller resolving many sets and passed in.
    [comment:2](/docs/references/automation/catzc-base-globs/private/Get-GlobSetMember.ps1.md#comment2)
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
