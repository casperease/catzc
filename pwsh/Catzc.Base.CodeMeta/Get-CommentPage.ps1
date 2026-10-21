<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.CodeMeta/Get-CommentPage.ps1
    name: get-comment-page
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.CodeMeta/tests/Get-CommentPage.Tests.ps1
    cites:
      - ADR-PRIN-ONELIVE-ONEVERSION
      - ADR-REPO-COMMENTS-COMMENTPAGEPLACE
---
#>

function Get-CommentPage {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Path
    )

    $page = (Get-Config -Config comment-pages).PageFor($Path)
    if ($page) {
        $page
    }
}
