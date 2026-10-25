<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-docs/Get-MarkdownListItem.ps1.md"
  warning: "Generated Header"
---
#>

function Get-MarkdownListItem {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]] $Line
    )

    $start = 0
    $first = $null
    $text = $null
    for ($i = 0; $i -lt $Line.Count; $i++) {
        $current = $Line[$i]
        if ($current -match '^\s*(-|\d+\.) ') {
            if ($start -gt 0) {
                [pscustomobject]@{ LineNumber = $start; First = $first; Text = $text }
            }
            $start = $i + 1
            $first = $current
            $text = $current
        }
        elseif ($start -gt 0 -and $current -match '^\s{2,}\S') {
            $text += ' ' + $current.Trim()
        }
        elseif ($start -gt 0) {
            [pscustomobject]@{ LineNumber = $start; First = $first; Text = $text }
            $start = 0
        }
    }
    if ($start -gt 0) {
        [pscustomobject]@{ LineNumber = $start; First = $first; Text = $text }
    }
}
