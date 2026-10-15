<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/Get-PropertyMetaState.ps1
    kind: public-function
    module: Catzc.Base.CodeMeta
    visibility: public
    adrs:
      - ADR-REPO-FILEMETA#8
---
#>

<#
.SYNOPSIS
    Reads what a JSON text says about its own meta property, without changing it.
.DESCRIPTION
    Pure: it takes the text and the property's name, reads no file and no config
    ([ADR-REPO-FILEMETA#8](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta8)).
.PARAMETER Text
    The whole JSON file as text.
.PARAMETER Property
    The name of the ignored top-level property that holds the block (e.g. // or $comment).
.PARAMETER Strip
    Beginnings of old values of the property that Format-PropertyMetaHead replaces instead of leaving as foreign.
.OUTPUTS
    [pscustomobject] @{ IsObject; HasHead; Foreign; Sections; DerivedKeys; ConfigLines } — Sections are the keys directly under `catzc`,
    DerivedKeys the keys under `derived`, and ConfigLines the authored lines under `config`, as written.
.EXAMPLE
    Get-PropertyMetaState -Text $text -Property '//' | Select-Object -ExpandProperty DerivedKeys
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
        IsObject    = $head.IsObject
        HasHead     = $head.HasHead
        Foreign     = $head.Foreign
        Sections    = [string[]] @($head.Sections)
        DerivedKeys = [string[]] @($head.DerivedKeys)
        ConfigLines = [string[]] @($head.ConfigLines)
    }
}
