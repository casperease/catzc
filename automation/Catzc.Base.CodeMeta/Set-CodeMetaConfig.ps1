<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/Set-CodeMetaConfig.ps1
    kind: automation-function
    module: Catzc.Base.CodeMeta
    visibility: public
    adrs:
      - ADR-REPO-FILEMETA#1
  config:
    synopsis: Returns a code text with the `config` lines of its meta head replaced, the derived part kept as it is.
    description: A text with no head comes back as it was, and no lines remove the config part (ADR-REPO-FILEMETA#1).
    parameters:
      Text: The whole code file as text.
      Form: 'The head''s comment syntax: a Catzc.Base.CodeMeta.HeadForm.'
      Config: The authored lines under `config`, as written, indented four spaces for a key of the part.
    outputs: '[string] the whole text, with the config part replaced.'
---
#>

function Set-CodeMetaConfig {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.HeadForm] $Form,

        [AllowEmptyCollection()]
        [string[]] $Config = @()
    )

    $head = [Catzc.Base.CodeMeta.CodeMetaHead]::Parse($Text, $Form)
    if (-not $head.HasHead) {
        return $Text
    }
    $head.WithConfig([string[]] @($Config))
}
