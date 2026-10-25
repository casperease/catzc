<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-code-meta/Get-CommentPage.ps1.md"
  warning: "Generated Header"
---
#>

function Get-CommentPage {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.CommentPagesConfig] $Config
    )

    $page = $Config.PageFor($Path)
    if ($page) {
        $page
    }
}
