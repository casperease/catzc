<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/ConvertTo-Guid.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Converts a sentence into a valid GUID whose hex digits best-effort spell the sentence.
.DESCRIPTION
    Total and deterministic: any non-empty input gives a valid GUID; unmappable characters become 0.
.PARAMETER Sentence
    The sentence to convert. Case-insensitive; must be non-empty and non-whitespace.
.OUTPUTS
    [guid] The minted GUID.
.EXAMPLE
    ConvertTo-Guid 'sample test data'
    Returns 5a001e00-7e57-da7a-0000-000000000000 — one word per dash group.
.EXAMPLE
    ConvertTo-Guid 'alpha test tenant'
    Returns a100a000-7e57-7e0a-0700-000000000000.
#>
function ConvertTo-Guid {
    [CmdletBinding()]
    [OutputType([guid])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Sentence
    )

    Assert-NotNullOrWhitespace $Sentence

    [Catzc.Base.QualityGates.SentenceGuid]::Convert($Sentence)
}
