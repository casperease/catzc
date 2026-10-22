<#
---
catzc:
  immutable:
    with_body_sha: "293ecdf7b80d"
  edges:
    test: pwsh/Catzc.Base.CodeMeta/tests/Get-CommentPage.Tests.ps1
    docs: "[Get-CommentPage.ps1.md](../../docs/references/pwsh/catzc-base-code-meta/Get-CommentPage.ps1.md)"
    cites:
      - ADR-REPO-COMMENTS-COMMENTPAGEPLACE
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
