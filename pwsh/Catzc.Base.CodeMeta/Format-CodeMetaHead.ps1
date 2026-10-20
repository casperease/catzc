<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.CodeMeta/Format-CodeMetaHead.ps1
    name: format-code-meta-head
    filetype: ps1
    role: function
    subkind: formatter
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.CodeMeta/tests/Format-CodeMetaHead.Tests.ps1
    docs: "[Format-CodeMetaHead.ps1.md](docs/references/pwsh/catzc-base-codemeta/Format-CodeMetaHead.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
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
