<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
    folder: private
    name: get-glob-set-member
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
    docs: "[Get-GlobSetMember.ps1.md](docs/references/pwsh/catzc-base-globs/private/Get-GlobSetMember.ps1.md)"
    cites:
      - ADR-FLOW-CD-GLOBS-TRACKEDFILESONLY
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
