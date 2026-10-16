<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-PsModule.ps1
    kind: function
    subkind: assert
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder-module
    bundle: minimal
    visibility: public
    relatives:
      test: automation/Catzc.Base.Asserts/tests/Assert-PsModule.Tests.ps1
  config:
    synopsis: Asserts that a PowerShell module is available.
    parameters:
      Module: The module name to look up via Get-Module -ListAvailable.
      ErrorText: Optional message to throw instead of the default.
    examples:
      - Assert-PsModule 'Pester'
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
