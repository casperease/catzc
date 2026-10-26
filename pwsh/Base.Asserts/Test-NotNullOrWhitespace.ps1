<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Test-NotNullOrWhitespace.ps1.md"
  header: "generated"
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
