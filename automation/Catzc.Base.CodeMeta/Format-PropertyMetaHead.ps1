<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/Format-PropertyMetaHead.ps1
    name: format-property-meta-head
    filetype: ps1
    kind: function
    subkind: formatter
    language: powershell
    track: automation
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.CodeMeta/tests/Format-PropertyMetaHead.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#8
  config:
    synopsis: Returns a JSON text with its meta property imprinted from the given facts.
    description: |-
      The same facts always give the same bytes, so a second run changes no file (ADR-REPO-FILEMETA#8). A text that is no JSON object, or
      whose property holds something else, comes back as it was.
    parameters:
      Text: The whole JSON file as text.
      Property: The name of the ignored top-level property that holds the block (e.g. // or $comment).
      Strip: Beginnings of old values of the property that are replaced.
      Immutable: The place facts, an ordered dictionary of key to value.
      Edges: The outgoing edges, an ordered dictionary of edge name to value; no facts and no edges removes the property.
    outputs: '[string] the whole text, with the property written first.'
    examples:
      - Format-PropertyMetaHead -Text $text -Property '//' -Immutable ([ordered]@{ path = 'widget/gadget.json'; kind = 'other' })
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

        [System.Collections.IDictionary] $Edges = [ordered]@{}
    )

    [Catzc.Base.CodeMeta.PropertyHead]::Parse($Text, $Property, $Strip).WithFacts($Immutable, $Edges)
}
