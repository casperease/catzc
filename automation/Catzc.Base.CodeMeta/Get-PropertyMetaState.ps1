<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/Get-PropertyMetaState.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    adrs:
      - ADR-REPO-FILEMETA#8
  config:
    synopsis: Reads what a JSON text says about its own meta property, without changing it.
    description: |-
      Pure: it takes the text and the property's name, reads no file and no config
      ([ADR-REPO-FILEMETA#8](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta8)).
    parameters:
      Text: The whole JSON file as text.
      Property: The name of the ignored top-level property that holds the block (e.g. // or $comment).
      Strip: Beginnings of old values of the property that Format-PropertyMetaHead replaces instead of leaving as foreign.
    outputs: |-
      [pscustomobject] @{ IsObject; HasHead; Foreign; Sections; DerivedKeys; ConfigLines } — Sections are the keys directly under `catzc`,
      DerivedKeys the keys under `derived`, and ConfigLines the authored lines under `config`, as written.
    examples:
      - Get-PropertyMetaState -Text $text -Property '//' | Select-Object -ExpandProperty DerivedKeys
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
        IsObject    = $head.IsObject
        HasHead     = $head.HasHead
        Foreign     = $head.Foreign
        Sections    = [string[]] @($head.Sections)
        DerivedKeys = [string[]] @($head.DerivedKeys)
        ConfigLines = [string[]] @($head.ConfigLines)
    }
}
