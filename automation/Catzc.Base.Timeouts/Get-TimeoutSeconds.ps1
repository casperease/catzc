<#
.SYNOPSIS
    Returns how many seconds a call may run before its time safeguard stops it.
.DESCRIPTION
    Resolves the limit from timeouts.yml for the run environment this session is in (Get-RunEnvironment: devbox or
    pipeline). With -Executable it is the executable's own entry under `executables` when it has one, otherwise the
    environment's pwsh limit. With -Shell it is that shell's limit: bash has a foreground and a -Background limit
    (the ones the Claude Code hook enforces), pwsh has one. Every consumer of the safeguard (Invoke-Executable,
    Invoke-WithTimeout, Assert-CompletesWithin, the hook's parity test) asks here, so tuning a limit is one edit to
    the config.
.PARAMETER Executable
    The executable the call runs. A directory and an extension are ignored (`C:\tools\dotnet.exe` resolves as
    `dotnet`).
.PARAMETER Shell
    The shell whose limit to return: Pwsh (the default) or Bash.
.PARAMETER Background
    Return the bash background limit instead of the foreground one. Bash only.
.PARAMETER EnvironmentAssertIs
    Pins the expected run environment (Pipeline or Devbox); a different one throws. The guard verifies, it never
    selects.
.EXAMPLE
    Get-TimeoutSeconds                          # the environment's pwsh limit
.EXAMPLE
    Get-TimeoutSeconds -Executable dotnet       # dotnet's own limit, or the environment's pwsh limit
.EXAMPLE
    Get-TimeoutSeconds -Shell Bash -Background  # the hook's limit for a background Bash call here
#>
function Get-TimeoutSeconds {
    [CmdletBinding(DefaultParameterSetName = 'Shell')]
    [OutputType([int])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Executable')]
        [AllowEmptyString()]
        [string] $Executable,
        [Parameter(ParameterSetName = 'Shell')]
        [ValidateSet('Pwsh', 'Bash')]
        [string] $Shell = 'Pwsh',
        [Parameter(ParameterSetName = 'Shell')]
        [switch] $Background,
        [ValidateSet('Pipeline', 'Devbox')]
        [string] $EnvironmentAssertIs
    )

    $guard = @{}
    if ($EnvironmentAssertIs) {
        $guard.EnvironmentAssertIs = $EnvironmentAssertIs
    }
    $environment = Get-RunEnvironment @guard
    $config = Get-Config -Config timeouts
    if ($PSCmdlet.ParameterSetName -eq 'Executable') {
        return $config.SecondsForExecutable($environment, $Executable)
    }
    $config.SecondsFor($environment, $Shell, $Background.IsPresent)
}
