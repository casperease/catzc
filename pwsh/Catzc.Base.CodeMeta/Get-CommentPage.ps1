<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-code-meta/Get-CommentPage.ps1.md"
  header: "generated"
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

    # The namespace of the track the path's first folder roots, read once per folder; a folder that roots no track has none.
    $root = $Path.Replace('\', '/').Split('/')[0]
    if (-not (Test-Path variable:script:commentPageNamespaces)) {
        $script:commentPageNamespaces = @{}
    }
    if (-not $script:commentPageNamespaces.ContainsKey($root)) {
        $track = @(Get-Track | Where-Object { $_.name -ceq $root })
        $script:commentPageNamespaces[$root] = if ($track.Count -gt 0) {
            $track[0].namespace
        }
        else {
            ''
        }
    }
    $page = $Config.PageFor($Path, $script:commentPageNamespaces[$root])
    if ($page) {
        $page
    }
}
