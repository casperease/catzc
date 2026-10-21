<#
---
catzc:
  immutable:
    with_body_sha: "14bb4d64da53"
  edges:
    docs: "[Get-PropertyMetaState.ps1.md](../../docs/references/pwsh/catzc-base-code-meta/Get-PropertyMetaState.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-JSONCARRIER
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
