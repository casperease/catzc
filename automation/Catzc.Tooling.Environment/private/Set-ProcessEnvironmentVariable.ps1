<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Environment/private/Set-ProcessEnvironmentVariable.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Environment
    visibility: private
  config:
    synopsis: Sets or removes a process-scope environment variable — the mockable I/O boundary for Write-EnvironmentSet.
    description: |-
      The single seam through which Write-EnvironmentSet WRITES and restores $env: values, wrapping
      [Environment]::SetEnvironmentVariable(name, value, 'Process'). A $null value removes the variable (this is
      how a scoped restore returns a previously-unset variable to unset). Tests mock this boundary
      (`Mock Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment`) instead of mutating the real
      process environment. This is the deliberately thin, un-mockable I/O boundary, so it has no unit test of its
      own (mirrors Set-EnvironmentPath).
    parameters:
      Name: The environment variable name to write.
      Value: The value to set. $null removes the variable.
    examples:
      - Set-ProcessEnvironmentVariable -Name 'GH_TOKEN' -Value $plaintext
---
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
