<#
---
catzc:
  immutable:
    with_body_sha: "3f5e3b2943c3"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-PsModule.Tests.ps1
    docs: "[Assert-PsModule.ps1.md](../../docs/references/pwsh/catzc-base-asserts/Assert-PsModule.ps1.md)"
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
