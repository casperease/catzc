<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Environment/Set-PermanentEnvironmentVariable.ps1
    name: set-permanent-environment-variable
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Environment
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-environment/Set-PermanentEnvironmentVariable.ps1.md
    test: automation/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1
    cites:
      - ADR-AUTO-CONSOLE#11
  config:
    synopsis: Writes, or removes, an environment variable in a persistent scope (the Windows registry for User/Machine).
    description: |-
      The single seam through which tooling WRITES a persistent environment variable other than PATH (PATH has its
      own, Set-EnvironmentPath), so a logic test can Mock the registry boundary
      (`Mock Set-PermanentEnvironmentVariable -ModuleName <module>`) instead of changing the real user environment,
      which every other process and every concurrent test run on the machine shares. User/Machine scopes are a
      Windows concept; callers guard Windows-only use with $IsWindows.

      Because every such write passes through here, this is also where it is announced
      ([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)): one
      line names the scope, the variable and the change. Writing the value the scope already holds — or removing a
      variable that is not set — is a no-op, so it neither writes nor announces.

      This is the thin I/O boundary itself, so its test is the vertical system test (L3): a real round trip through
      the user environment.
    parameters:
      Name: The variable's name.
      Value: The value to persist. $null or empty removes the variable from the scope.
      Scope: 'Which persistent scope to write: User (default) or Machine.'
    examples:
      - Set-PermanentEnvironmentVariable JAVA_HOME 'C:\jdk-21'
      - 'Set-PermanentEnvironmentVariable JAVA_HOME $null   # remove it'
---
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
        [System.Environment]::SetEnvironmentVariable($Name, [NullString]::Value, $Scope)
        Write-Message "$Scope environment: removed $Name"
    }
    else {
        [System.Environment]::SetEnvironmentVariable($Name, $Value, $Scope)
        Write-Message "$Scope environment: set $Name to '$Value'"
    }
}
