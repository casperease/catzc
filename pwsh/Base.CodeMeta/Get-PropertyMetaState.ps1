<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-code-meta/Get-PropertyMetaState.ps1.md"
  header: "generated"
---
#>

function Get-PropertyMetaState {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string] $Property,

        [string[]] $Strip = @()
    )

    $head = [Catzc.Base.CodeMeta.PropertyHead]::Parse($Text, $Property, $Strip)
    [pscustomobject]@{
        IsObject      = $head.IsObject
        HasHead       = $head.HasHead
        Foreign       = $head.Foreign
        Sections      = [string[]] @($head.Sections)
        ImmutableKeys = [string[]] @($head.ImmutableKeys)
        EdgeKeys      = [string[]] @($head.EdgeKeys)
        ConfigLines   = [string[]] @($head.ConfigLines)
        # The text without the imprinted parts, the body a generated file's writer hashes too.
        Body          = $head.IsObject ? $head.WithFacts([ordered]@{}, [ordered]@{}) : $Text
    }
}
