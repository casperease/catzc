<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-code-meta/Format-CodeMetaHead.ps1.md"
  warning: "Generated Header"
---
#>

function Format-CodeMetaHead {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.HeadForm] $Form,

        [System.Collections.IDictionary] $Immutable = [ordered]@{},

        [System.Collections.IDictionary] $Edges = [ordered]@{},

        [string] $HeaderText = ''
    )

    [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($Text, $Form).WithFacts($HeaderText, $Immutable, $Edges)
}
