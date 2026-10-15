<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Environment/Get-PermanentEnvironmentVariable.ps1
    kind: function
    module: Catzc.Base.Environment
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Reads an environment variable from a persistent scope (the Windows registry for User/Machine).
.DESCRIPTION
    The one read seam for persistent variables other than PATH, so tests mock it; the scopes are Windows only.
.PARAMETER Name
    The variable's name.
.PARAMETER Scope
    Which persistent scope to read: User (default) or Machine.
.OUTPUTS
    [string] the value, or $null when the variable is not set in that scope.
.EXAMPLE
    Get-PermanentEnvironmentVariable JAVA_HOME
#>
function Get-PermanentEnvironmentVariable {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [ValidateSet('User', 'Machine')]
        [string] $Scope = 'User'
    )

    [System.Environment]::GetEnvironmentVariable($Name, $Scope)
}
