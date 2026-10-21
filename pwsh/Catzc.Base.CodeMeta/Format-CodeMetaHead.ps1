<#
---
catzc:
  immutable:
    with_body_sha: dace363b0196
  edges:
    test: pwsh/Catzc.Base.CodeMeta/tests/Format-CodeMetaHead.Tests.ps1
    docs: "[Format-CodeMetaHead.ps1.md](docs/references/pwsh/catzc-base-code-meta/Format-CodeMetaHead.ps1.md)"
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
