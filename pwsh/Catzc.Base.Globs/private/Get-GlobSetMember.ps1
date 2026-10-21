<#
---
catzc:
  immutable:
    with_body_sha: "5efc525b5fb7"
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
    docs: "[Get-GlobSetMember.ps1.md](docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md)"
    cites:
      - FDR-CD-GLOBS-TRACKEDFILESONLY
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
