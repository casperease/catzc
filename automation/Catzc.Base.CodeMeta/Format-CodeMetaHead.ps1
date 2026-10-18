<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.CodeMeta/Format-CodeMetaHead.ps1
    name: format-code-meta-head
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
    test: automation/Catzc.Base.CodeMeta/tests/Format-CodeMetaHead.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#3
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

        [System.Collections.IDictionary] $Immutable = [ordered]@{},

        [System.Collections.IDictionary] $Edges = [ordered]@{}
    )

    [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($Text, $Form).WithFacts($Immutable, $Edges)
}
