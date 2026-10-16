<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Environment/Get-PermanentEnvironmentVariable.ps1
    name: get-permanent-environment-variable
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Environment
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Reads an environment variable from a persistent scope (the Windows registry for User/Machine).
    description: |-
      The single seam through which tooling READS a persistent environment variable other than PATH (PATH has its
      own, Get-EnvironmentPath), so a logic test can Mock the registry boundary
      (`Mock Get-PermanentEnvironmentVariable -ModuleName <module>`) instead of reading the real user environment.
      User/Machine scopes are a Windows concept; callers guard Windows-only use with $IsWindows. The real
      registry round trip is proven by the L3 system test in tests/Set-PermanentEnvironmentVariable.Tests.ps1.
    parameters:
      Name: The variable's name.
      Scope: 'Which persistent scope to read: User (default) or Machine.'
    outputs: '[string] the value, or $null when the variable is not set in that scope.'
    examples:
      - Get-PermanentEnvironmentVariable JAVA_HOME
---
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
