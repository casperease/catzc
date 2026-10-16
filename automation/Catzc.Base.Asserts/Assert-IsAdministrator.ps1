<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/Assert-IsAdministrator.ps1
    name: assert-is-administrator
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
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
