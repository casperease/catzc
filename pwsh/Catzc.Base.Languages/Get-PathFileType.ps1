<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Languages/Get-PathFileType.ps1
    name: get-path-file-type
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Languages/tests/Get-PathFileType.Tests.ps1
    docs: "[Get-PathFileType.ps1.md](docs/references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md)"
    cites:
      - ADR-DSGN-TRACK-FILELANGUAGE
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
