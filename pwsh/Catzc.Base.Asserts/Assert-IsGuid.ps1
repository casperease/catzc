<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-IsGuid.ps1.md"
  warning: "Generated Header"
---
#>

function Assert-IsGuid {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ObjectGuid
    )

    if (-not (Test-IsGuid $ObjectGuid)) {
        throw "'$ObjectGuid' is not a valid GUID"
    }
}
