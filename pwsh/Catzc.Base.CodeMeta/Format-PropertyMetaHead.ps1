<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.CodeMeta/Format-PropertyMetaHead.ps1
    name: format-property-meta-head
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
