<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Get-FileKind.ps1
    name: get-file-kind
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Globs/tests/Get-FileKind.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#2
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
