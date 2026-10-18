<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Languages/Get-PathFileType.ps1
    name: get-path-file-type
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
    cites:
      - ADR-DSGN-TRACK#6
---
#>

function Get-PathFileType {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    $fileType = [Catzc.Base.Languages.PathParts]::FileTypeOf($Path)
    if ($fileType) {
        $fileType
    }
}
