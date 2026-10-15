<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/Format-CodeMetaHead.ps1
    kind: function
    module: Catzc.Base.CodeMeta
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns a code text with its meta head imprinted from the given facts.
.DESCRIPTION
    The same facts always give the same bytes, so a second run changes no file and a formatter never undoes the head.
    [ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)
    [comment:1](/docs/references/automation/catzc-base-codemeta/Format-CodeMetaHead.ps1.md#comment1)
.PARAMETER Text
    The whole code file as text.
.PARAMETER Form
    The head's comment syntax: a Catzc.Base.CodeMeta.HeadForm.
.PARAMETER Fact
    The derived facts, an ordered dictionary of key to value; no facts removes the head.
.OUTPUTS
    [string] the whole text, with the head replaced.
.EXAMPLE
    Format-CodeMetaHead -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')) -Fact ([ordered]@{ path = 'automation/Widget/types/Gadget.cs'; module = 'Widget' })
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
