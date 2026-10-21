<#
---
catzc:
  immutable:
    with_body_sha: c88d84510726
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
