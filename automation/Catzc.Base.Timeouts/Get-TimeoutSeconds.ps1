<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/Get-TimeoutSeconds.ps1
    kind: function
    module: Catzc.Base.Timeouts
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns how many seconds a call may run before its time safeguard stops it.
.DESCRIPTION
    Every safeguard consumer asks here, so tuning a limit is one config edit; a command's exemption outranks its entry.
    [ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)
    [comment:1](/docs/references/automation/catzc-base-timeouts/Get-TimeoutSeconds.ps1.md#comment1)
.PARAMETER Executable
    Directory and extension are ignored, so a full path to dotnet.exe resolves the same as plain dotnet.
    [comment:2](/docs/references/automation/catzc-base-timeouts/Get-TimeoutSeconds.ps1.md#comment2)
.PARAMETER Command
    The function must already be loaded, since its decoration is read from the loaded command.
    [comment:3](/docs/references/automation/catzc-base-timeouts/Get-TimeoutSeconds.ps1.md#comment3)
.PARAMETER Shell
    A name that is no execution engine throws and lists the valid shells, so a typo never falls back to pwsh.
    [comment:4](/docs/references/automation/catzc-base-timeouts/Get-TimeoutSeconds.ps1.md#comment4)
.PARAMETER Background
    Return the bash background limit instead of the foreground one. Bash only.
.PARAMETER Budget
    An exemption only raises the limit to its ceiling, never lowers it; the empty GUID means no budget.
    [comment:5](/docs/references/automation/catzc-base-timeouts/Get-TimeoutSeconds.ps1.md#comment5)
.PARAMETER EnvironmentAssertIs
    The guard only verifies the environment found at run time; it never selects which environment's limit is read.
    [comment:6](/docs/references/automation/catzc-base-timeouts/Get-TimeoutSeconds.ps1.md#comment6)
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
        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Shell = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name,
        [Parameter(ParameterSetName = 'Shell')]
        [switch] $Background,
        [Parameter(ParameterSetName = 'Shell')]
        [guid] $Budget = [guid]::Empty,
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
    if ($Budget -ne [guid]::Empty -and (Get-TimeoutExemption $Budget -Shell $Shell)) {
        # An exemption raises the limit to its ceiling while the work is tuned; it never lowers it.
        $seconds = [math]::Max($seconds, (Get-Config -Config timeout-exemptions).CeilingFor($environment, $Shell))
    }
    $seconds
}
