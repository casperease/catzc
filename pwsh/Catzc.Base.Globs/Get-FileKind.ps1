<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Get-FileKind.ps1.md"
  header: "generated"
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
