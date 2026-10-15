<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Environment/Get-EnvironmentPath.ps1
    kind: public-function
    module: Catzc.Base.Environment
    visibility: public
  config:
    synopsis: Reads the PATH environment variable at the scope given (the Windows registry for User/Machine).
    description: |-
      The single seam through which the PATH helpers (Add-/Remove-PermanentPath, Sync-SessionPath, the tooling
      uninstallers) READ the persistent PATH, so tests can Mock the registry boundary
      (`Mock Get-EnvironmentPath -ModuleName <module>`) instead of reading the real machine. Paired with
      Set-EnvironmentPath for writes. User/Machine scopes are a Windows concept; callers guard Windows-only use
      with $IsWindows. This is the deliberately thin, un-mockable I/O boundary, so it has no unit test of its
      own.
    parameters:
      Scope: 'Which environment scope to read: User (default), Machine, or Process.'
    examples:
      - 'Get-EnvironmentPath                 # User-scope PATH'
      - Get-EnvironmentPath -Scope Machine
---
#>

function Get-EnvironmentPath {
    [OutputType([string])]
    param(
        [ValidateSet('User', 'Machine', 'Process')]
        [string] $Scope = 'User'
    )

    [System.Environment]::GetEnvironmentVariable('PATH', $Scope)
}
