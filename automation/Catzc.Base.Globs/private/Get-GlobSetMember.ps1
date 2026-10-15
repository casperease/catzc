<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
    kind: automation-function
    module: Catzc.Base.Globs
    visibility: private
    adrs:
      - ADR-FLOW-CD-GLOBS#4
  config:
    synopsis: The tracked files a globset finally selects — the single source of a set's included members.
    description: |-
      The one definition of "what is IN the package"
      ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): the matching universe
      (`git ls-files`)
      intersected with the set's final membership (GlobSet.Matches, last-match-wins), ordinal-sorted. Every
      consumer of the member list routes through here — the durable content SHA (Get-GlobSetHash), the public
      Get-GlobSetFile — so the scoped list can never drift between the hash and the public file list. A member
      may be missing on disk (an unstaged deletion); it is still a member.
    parameters:
      GlobSet: The globset instance to resolve (declared or derived).
      TrackedFile: |-
        The tracked-file universe (Get-TrackedFile), fetched once by a caller resolving many sets and passed in.
        Omitted, it is fetched for this call.
    examples:
      - Get-GlobSetMember -GlobSet (Get-GlobSet -Name automation)
---
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
