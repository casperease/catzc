<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/ConvertTo-Guid.ps1.md"
  warning: "Generated Header"
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
