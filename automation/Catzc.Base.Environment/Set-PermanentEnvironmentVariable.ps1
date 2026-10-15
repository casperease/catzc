<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Environment/Set-PermanentEnvironmentVariable.ps1
    kind: public-function
    module: Catzc.Base.Environment
    visibility: public
    adrs:
      - ADR-AUTO-CONSOLE#11
---
#>

<#
.SYNOPSIS
    Writes, or removes, an environment variable in a persistent scope (the Windows registry for User/Machine).
.DESCRIPTION
    The one write seam for persistent variables other than PATH, so tests spare the shared user environment.
.PARAMETER Name
    The variable's name.
.PARAMETER Value
    The value to persist. $null or empty removes the variable from the scope.
.PARAMETER Scope
    Which persistent scope to write: User (default) or Machine.
.EXAMPLE
    Set-PermanentEnvironmentVariable JAVA_HOME 'C:\jdk-21'
.EXAMPLE
    Set-PermanentEnvironmentVariable JAVA_HOME $null   # remove it
#>
function Set-PermanentEnvironmentVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Thin wrapper around [Environment]::SetEnvironmentVariable — the registry I/O seam that exists for testability; guarding/dry-run is the caller''s concern.')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory, Position = 1)]
        [AllowNull()]
        [AllowEmptyString()]
        [string] $Value,

        [ValidateSet('User', 'Machine')]
        [string] $Scope = 'User'
    )

    $current = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
    $removing = [string]::IsNullOrEmpty($Value)
    if (($removing -and [string]::IsNullOrEmpty($current)) -or (-not $removing -and $current -ceq $Value)) {
        return
    }

    if ($removing) {
        # A plain $null arrives as '' and is stored as an empty value; only a real null deletes the variable.
        # [comment:2](/docs/references/automation/catzc-base-environment/Set-PermanentEnvironmentVariable.ps1.md#comment2)
        [System.Environment]::SetEnvironmentVariable($Name, [NullString]::Value, $Scope)
        Write-Message "$Scope environment: removed $Name"
    }
    else {
        [System.Environment]::SetEnvironmentVariable($Name, $Value, $Scope)
        Write-Message "$Scope environment: set $Name to '$Value'"
    }
}
