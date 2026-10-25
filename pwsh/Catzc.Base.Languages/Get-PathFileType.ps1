<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-languages/Get-PathFileType.ps1.md"
  warning: "Generated Header"
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
