<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-PsModule.ps1.md"
  warning: "Generated Header"
---
#>

function Assert-PsModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $ErrorText
    )

    if (-not (Get-Module $Module -ListAvailable)) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Module '$Module' is not available"
        }
        throw $message
    }
}
