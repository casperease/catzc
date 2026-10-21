<#
---
catzc:
  immutable:
    with_body_sha: "20a5b7aaf034"
  edges:
    test: pwsh/Catzc.Base.CodeMeta/tests/Format-PropertyMetaHead.Tests.ps1
    docs: "[Format-PropertyMetaHead.ps1.md](docs/references/pwsh/catzc-base-codemeta/Format-PropertyMetaHead.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-JSONCARRIER
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
