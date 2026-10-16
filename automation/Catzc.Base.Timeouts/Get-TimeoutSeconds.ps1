<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/Get-TimeoutSeconds.ps1
    name: get-timeout-seconds
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Timeouts/tests/Get-TimeoutSeconds.Tests.ps1
    adrs:
      - ADR-PWSH-ASSERT#1
  config:
    synopsis: Returns how many seconds a call may run before its time safeguard stops it.
    description: |-
      Resolves the limit from timeouts.yml for the run environment this session is in (Get-RunEnvironment: devbox or
      pipeline). With -Executable it is the executable's own entry under `executables` when it has one, otherwise the
      environment's pwsh limit. With -Shell it is that shell's limit: bash has a foreground and a -Background limit
      (the ones the Claude Code hook enforces, since the hook governs the Bash tool), and every other engine has one.
      With -Command it is a function's own limit, most specific
      first: an exemption for its [TimeLimit] decoration's budget GUID, then its entry under `commands`, then the
      decoration for this environment, then the environment's pwsh limit
      ([ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)). Every consumer of the safeguard (Invoke-Executable,
      Invoke-WithTimeout, Assert-CompletesWithin, the hook's parity test) asks here, so tuning a limit is one edit to
      the config.
    parameters:
      Executable: |-
        The executable the call runs. A directory and an extension are ignored (`C:\tools\dotnet.exe` resolves as
        `dotnet`).
      Command: |-
        The function whose own limit to return — its [Catzc.Base.Timeouts.TimeLimit] decoration, unless config overrides it.
        The function must be loaded.
      Shell: |-
        The shell whose limit to return, one of the execution engines (pwsh, bash or zsh); pwsh is the default. Any other name
        throws, naming the shells.
      Background: Return the bash background limit instead of the foreground one. Bash only.
      Budget: |-
        The work's immutable budget GUID. When timeout-exemptions.yml exempts it here, the limit is raised to the
        exemption ceiling (never lowered). Omitted (the empty GUID) means no budget.
      EnvironmentAssertIs: |-
        Pins the expected run environment (Pipeline or Devbox); a different one throws. The guard verifies, it never
        selects.
    examples:
      - 'Get-TimeoutSeconds                          # the environment''s pwsh limit'
      - 'Get-TimeoutSeconds -Executable dotnet       # dotnet''s own limit, or the environment''s pwsh limit'
      - 'Get-TimeoutSeconds -Shell Bash -Background  # the hook''s limit for a background Bash call here'
      - 'Get-TimeoutSeconds -Budget $budget          # the pwsh limit, or the exemption ceiling while $budget is exempt'
      - 'Get-TimeoutSeconds -Command Test-Automation # Test-Automation''s own limit, from its [TimeLimit] unless config overrides it'
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
