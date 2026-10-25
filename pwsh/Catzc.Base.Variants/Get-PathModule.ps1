<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Get-PathModule.ps1.md"
  header: "generated"
---
#>

function Get-PathModule {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.PathModule])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    $module = (Get-Config -Config module-types).Resolve($Path)
    if ($module) {
        $module
    }
}
