<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/ConvertTo-Guid.ps1
    name: convert-to-guid
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/ConvertTo-Guid.Tests.ps1
    docs: "[ConvertTo-Guid.ps1.md](docs/references/pwsh/catzc-base-qualitygates/ConvertTo-Guid.ps1.md)"
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
