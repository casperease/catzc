<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-code-meta/Format-PropertyMetaHead.ps1.md"
  warning: "Generated Header"
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

        [string] $WarningText = ''
    )

    [Catzc.Base.CodeMeta.PropertyHead]::Parse($Text, $Property, $Strip).WithFacts($WarningText, $Immutable, $Edges)
}
