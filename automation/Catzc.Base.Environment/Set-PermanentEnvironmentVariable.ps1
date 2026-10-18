<#
---
catzc:
  immutable:
    repo_status: clean
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
