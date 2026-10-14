<#
.SYNOPSIS
    Returns how many seconds a call may run before its time safeguard stops it.
.DESCRIPTION
    Resolves the limit from timeouts.yml: the executable's own entry under `executables` when it has one,
    otherwise `default_seconds`. Every consumer of the safeguard (Invoke-Executable, Invoke-WithTimeout,
    Assert-CompletesWithin) asks here, so tuning a limit is one edit to the config.
.PARAMETER Executable
    The executable the call runs. A directory and an extension are ignored (`C:\tools\dotnet.exe` resolves as
    `dotnet`). Omit it for the default limit.
.EXAMPLE
    Get-TimeoutSeconds                     # default_seconds
.EXAMPLE
    Get-TimeoutSeconds -Executable dotnet  # dotnet's own limit, or default_seconds
#>
function Get-TimeoutSeconds {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [string] $Executable
    )

    (Get-Config -Config timeouts).SecondsFor($Executable)
}
