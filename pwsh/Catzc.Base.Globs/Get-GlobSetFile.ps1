<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/Get-GlobSetFile.ps1
    name: get-glob-set-file
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
    docs: "[Get-GlobSetFile.ps1.md](docs/references/pwsh/catzc-base-globs/Get-GlobSetFile.ps1.md)"
    cites:
      - ADR-FLOW-CD-GLOBS-TRACKEDFILESONLY
      - ADR-FLOW-CD-GLOBS-DURABLESHAIDENTITY
---
#>

function Get-GlobSetFile {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name
    )

    Get-GlobSetMember -GlobSet (Get-GlobSet -Name $Name)
}
