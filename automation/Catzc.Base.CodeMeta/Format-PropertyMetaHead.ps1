<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/Format-PropertyMetaHead.ps1
    kind: format-function
    module: Catzc.Base.CodeMeta
    visibility: public
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
      Fact: The derived facts, an ordered dictionary of key to value; no facts removes the property.
    outputs: '[string] the whole text, with the property written first.'
    examples:
      - Format-PropertyMetaHead -Text $text -Property '//' -Fact ([ordered]@{ path = 'widget/gadget.json'; kind = 'other' })
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

        [System.Collections.IDictionary] $Fact = [ordered]@{}
    )

    [Catzc.Base.CodeMeta.PropertyHead]::Parse($Text, $Property, $Strip).WithFacts($Fact)
}
