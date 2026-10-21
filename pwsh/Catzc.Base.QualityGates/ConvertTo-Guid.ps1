<#
---
catzc:
  immutable:
    with_body_sha: d7b01e863097
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/ConvertTo-Guid.Tests.ps1
    docs: "[ConvertTo-Guid.ps1.md](../../docs/references/pwsh/catzc-base-quality-gates/ConvertTo-Guid.ps1.md)"
---
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
