<#
---
catzc:
  immutable:
    with_body_sha: "293ecdf7b80d"
  edges:
    test: pwsh/Catzc.Base.CodeMeta/tests/Get-CommentPage.Tests.ps1
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
