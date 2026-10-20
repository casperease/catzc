<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/Get-FileKind.ps1
    name: get-file-kind
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
    test: pwsh/Catzc.Base.Globs/tests/Get-FileKind.Tests.ps1
    docs: "[Get-FileKind.ps1.md](docs/references/pwsh/catzc-base-globs/Get-FileKind.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-METAKIND
---
#>

function Get-FileKind {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Globs.FileKindMatch])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    (Get-Config -Config file-kinds).Resolve(($Path -replace '\\', '/'))
}
