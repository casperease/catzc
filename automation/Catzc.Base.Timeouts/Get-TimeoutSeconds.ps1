<#
.SYNOPSIS
    Returns how many seconds a call may run before its time safeguard stops it.
.DESCRIPTION
    Resolves the limit from timeouts.yml for the run environment this session is in (Get-RunEnvironment: devbox or
    pipeline). With -Executable it is the executable's own entry under `executables` when it has one, otherwise the
    environment's pwsh limit. With -Shell it is that shell's limit: bash has a foreground and a -Background limit
    (the ones the Claude Code hook enforces), pwsh has one. With -Command it is a function's own limit, most specific
    first: an exemption for its [TimeLimit] decoration's budget GUID, then its entry under `commands`, then the
    decoration for this environment, then the environment's pwsh limit
    ([ADR-AUTO-FAILFAST#8](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast8)). Every consumer of the safeguard (Invoke-Executable,
    Invoke-WithTimeout, Assert-CompletesWithin, the hook's parity test) asks here, so tuning a limit is one edit to
    the config.
.PARAMETER Executable
    The executable the call runs. A directory and an extension are ignored (`C:\tools\dotnet.exe` resolves as
    `dotnet`).
.PARAMETER Command
    The function whose own limit to return — its [Catzc.Base.Timeouts.TimeLimit] decoration, unless config overrides it.
    The function must be loaded.
.PARAMETER Shell
    The shell whose limit to return: Pwsh (the default) or Bash.
.PARAMETER Background
    Return the bash background limit instead of the foreground one. Bash only.
.PARAMETER Budget
    The work's immutable budget GUID. When timeout-exemptions.yml exempts it here, the limit is raised to the
    exemption ceiling (never lowered). Empty means no budget.
.PARAMETER EnvironmentAssertIs
    Pins the expected run environment (Pipeline or Devbox); a different one throws. The guard verifies, it never
    selects.
.EXAMPLE
    Get-TimeoutSeconds                          # the environment's pwsh limit
.EXAMPLE
    Get-TimeoutSeconds -Executable dotnet       # dotnet's own limit, or the environment's pwsh limit
.EXAMPLE
    Get-TimeoutSeconds -Shell Bash -Background  # the hook's limit for a background Bash call here
.EXAMPLE
    Get-TimeoutSeconds -Budget $budget          # the pwsh limit, or the exemption ceiling while $budget is exempt
.EXAMPLE
    Get-TimeoutSeconds -Command Test-Automation # Test-Automation's own limit, from its [TimeLimit] unless config overrides it
#>
function Get-TimeoutSeconds {
    [CmdletBinding(DefaultParameterSetName = 'Shell')]
    [OutputType([int])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Executable')]
        [AllowEmptyString()]
        [string] $Executable,
        [Parameter(Mandatory, ParameterSetName = 'Command')]
        [string] $Command,
        [Parameter(ParameterSetName = 'Shell')]
        [ValidateSet('Pwsh', 'Bash')]
        [string] $Shell = 'Pwsh',
        [Parameter(ParameterSetName = 'Shell')]
        [switch] $Background,
        [Parameter(ParameterSetName = 'Shell')]
        [AllowEmptyString()]
        [string] $Budget,
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
    if ($PSCmdlet.ParameterSetName -eq 'Command') {
        $function = Get-Command -Name $Command -CommandType Function -ErrorAction Ignore
        Assert-NotNull $function -ErrorText "Get-TimeoutSeconds: no loaded function named '$Command'."
        $decoration = $function.ScriptBlock.Attributes | Where-Object { $_ -is [Catzc.Base.Timeouts.TimeLimitAttribute] } | Select-Object -First 1
        $seconds = $config.SecondsForCommand($Command)
        if ($null -eq $seconds) {
            $seconds = if ($decoration) {
                $decoration.SecondsFor($environment)
            }
            else {
                $config.SecondsFor($environment, 'Pwsh', $false)
            }
        }
        if ($decoration -and $decoration.Budget -and (Get-TimeoutExemption $decoration.Budget -Shell Pwsh)) {
            # An exemption raises the limit to its ceiling while the work is tuned; it never lowers it.
            $seconds = [math]::Max($seconds, (Get-Config -Config timeout-exemptions).CeilingFor($environment, 'Pwsh'))
        }
        return $seconds
    }
    $seconds = $config.SecondsFor($environment, $Shell, $Background.IsPresent)
    if ($Budget -and (Get-TimeoutExemption $Budget -Shell $Shell)) {
        # An exemption raises the limit to its ceiling while the work is tuned; it never lowers it.
        $seconds = [math]::Max($seconds, (Get-Config -Config timeout-exemptions).CeilingFor($environment, $Shell))
    }
    $seconds
}
