<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-IsAdministrator.ps1
    kind: function
    subkind: assert
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder-module
    bundle: minimal
    visibility: public
  config:
    synopsis: Throws if the current session is not running as Administrator.
    parameters:
      ErrorText: Custom error message.
    examples:
      - Assert-IsAdministrator
---
#>

function Assert-IsAdministrator {
    param(
        [string] $ErrorText = 'This operation requires Administrator privileges'
    )

    Assert-True (Test-IsAdministrator) -ErrorText $ErrorText
}
