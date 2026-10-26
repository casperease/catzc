<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Test-IsGuid.ps1.md"
  header: "generated"
---
#>

function Test-IsGuid {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ObjectGuid
    )

    [guid]::TryParse($ObjectGuid, [ref][guid]::Empty)
}
