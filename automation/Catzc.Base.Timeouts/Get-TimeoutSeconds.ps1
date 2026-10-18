<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Timeouts/Get-TimeoutSeconds.ps1
    name: get-timeout-seconds
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Timeouts/tests/Get-TimeoutSeconds.Tests.ps1
    cites:
      - ADR-PWSH-ASSERT#1
---
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
