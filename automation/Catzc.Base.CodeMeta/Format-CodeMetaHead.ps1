<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/Format-CodeMetaHead.ps1
    name: format-code-meta-head
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
      test: automation/Catzc.Base.CodeMeta/tests/Format-CodeMetaHead.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: Returns a code text with its meta head imprinted from the given facts.
    description: |-
      The same facts always give the same bytes, so a second run changes no file and a formatter never undoes the head.
    parameters:
      Text: The whole code file as text.
      Form: 'The head''s comment syntax: a Catzc.Base.CodeMeta.HeadForm.'
      Fact: The derived facts, an ordered dictionary of key to value; no facts removes the head.
    outputs: '[string] the whole text, with the head replaced.'
    examples:
      - Format-CodeMetaHead -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')) -Fact ([ordered]@{ path = 'automation/Widget/types/Gadget.cs'; module = 'Widget' })
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

        [System.Collections.IDictionary] $Fact = [ordered]@{}
    )

    [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($Text, $Form).WithFacts($Fact)
}
