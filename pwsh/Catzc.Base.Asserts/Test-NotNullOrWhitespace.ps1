<#
---
catzc:
  immutable:
    with_body_sha: ea30aa682b34
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Test-NotNullOrWhitespace.Tests.ps1
    docs: "[Test-NotNullOrWhitespace.ps1.md](docs/references/pwsh/catzc-base-asserts/Test-NotNullOrWhitespace.ps1.md)"
---
#>

function Test-NotNullOrWhitespace {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [AllowNull()]
        [AllowEmptyString()]
        [string] $Value
    )

    -not [string]::IsNullOrWhiteSpace($Value)
}
