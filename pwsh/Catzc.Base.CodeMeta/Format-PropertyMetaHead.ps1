<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-code-meta/Format-PropertyMetaHead.ps1.md"
  header: "generated"
---
#>

function Format-PropertyMetaHead {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string] $Property,

        [string[]] $Strip = @(),

        [System.Collections.IDictionary] $Immutable = [ordered]@{},

        [System.Collections.IDictionary] $Edges = [ordered]@{},

        [string] $HeaderText = ''
    )

    [Catzc.Base.CodeMeta.PropertyHead]::Parse($Text, $Property, $Strip).WithFacts($HeaderText, $Immutable, $Edges)
}
