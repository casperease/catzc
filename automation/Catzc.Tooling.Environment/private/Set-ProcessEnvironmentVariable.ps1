<#
.SYNOPSIS
    Sets or removes a process-scope environment variable — the mockable I/O boundary for Write-EnvironmentSet.
.DESCRIPTION
    The single seam through which Write-EnvironmentSet WRITES and restores $env: values, wrapping
    [Environment]::SetEnvironmentVariable(name, value, 'Process'). A $null value removes the variable (this is
    how a scoped restore returns a previously-unset variable to unset). Tests mock this boundary
    (`Mock Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment`) instead of mutating the real
    process environment. This is the deliberately thin, un-mockable I/O boundary, so it has no unit test of its
    own (mirrors Set-EnvironmentPath).
.PARAMETER Name
    The environment variable name to write.
.PARAMETER Value
    The value to set. $null removes the variable.
.EXAMPLE
    Set-ProcessEnvironmentVariable -Name 'GH_TOKEN' -Value $plaintext
#>
function Set-ProcessEnvironmentVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Thin wrapper around [Environment]::SetEnvironmentVariable — the process-env I/O seam that exists for testability; scoping/restore is the caller''s concern (Write-EnvironmentSet).')]
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
