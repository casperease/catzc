<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.CodeMeta/Format-PropertyMetaHead.ps1
    name: format-property-meta-head
    filetype: ps1
    kind: function
    subkind: formatter
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.CodeMeta/tests/Format-PropertyMetaHead.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#8
  config:
    synopsis: Returns a JSON text or an MSBuild project with its meta property imprinted from the given facts.
    description: |-
      The block is the text of one property, in either carrier: in a JSON file an ignored top-level member, in an XML file whose root is an
      MSBuild project a CDATA property named for the block inside the first PropertyGroup labelled catzc. The same facts always give the
      same bytes, so a second run changes no file (ADR-REPO-FILEMETA#8). A text that is neither, or whose property holds something else,
      comes back as it was.
    parameters:
      Text: The whole JSON file or MSBuild project as text.
      Property: The name of the property that holds the block (e.g. // or $comment in JSON, CatzcMeta in a project).
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
