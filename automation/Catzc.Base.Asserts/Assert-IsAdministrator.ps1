<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-IsAdministrator.ps1
    kind: assert-function
    module: Catzc.Base.Asserts
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Throws if the current session is not running as Administrator.
.PARAMETER ErrorText
    Custom error message.
.EXAMPLE
    Assert-IsAdministrator
#>
function Assert-IsAdministrator {
    param(
        [string] $ErrorText = 'This operation requires Administrator privileges'
    )

    Assert-True (Test-IsAdministrator) -ErrorText $ErrorText
}
