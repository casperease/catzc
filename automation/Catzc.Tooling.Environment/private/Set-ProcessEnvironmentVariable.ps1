<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Environment/private/Set-ProcessEnvironmentVariable.ps1
    kind: function
    module: Catzc.Tooling.Environment
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Sets or removes a process-scope environment variable — the mockable I/O boundary for Write-EnvironmentSet.
.DESCRIPTION
    A null value removes the variable, which is how a scoped restore returns an unset variable to unset.
    [comment:1](/docs/references/automation/catzc-tooling-environment/private/Set-ProcessEnvironmentVariable.ps1.md#comment1)
.PARAMETER Name
    The environment variable name to write.
.PARAMETER Value
    The value to set. $null removes the variable.
.EXAMPLE
    Set-ProcessEnvironmentVariable -Name 'GH_TOKEN' -Value $plaintext
#>
function Set-ProcessEnvironmentVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Thin wrapper around [Environment]::SetEnvironmentVariable — the process-env I/O seam that exists for testability; scoping/restore is the caller''s concern (Write-EnvironmentSet).')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Its one caller, Write-EnvironmentSet, announces every variable it sets with secrets masked (***); announcing here would print the plaintext secret')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [AllowNull()]
        [AllowEmptyString()]
        $Value
    )

    [System.Environment]::SetEnvironmentVariable($Name, $Value, 'Process')
}
