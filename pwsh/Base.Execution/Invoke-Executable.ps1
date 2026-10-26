<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md"
  header: "generated"
---
#>

# -DryRun, not -WhatIf; the result splits Output (stdout), Errors (stderr), Full (merged in order), ExitCode and Raw.
function Invoke-Executable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '',
        Justification = 'By design — executes CLI commands via private helpers')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '',
        Justification = 'Returns string in -DryRun, Catzc.Base.Execution.CliResult in -PassThru')]
    [CmdletBinding(DefaultParameterSetName = 'Stream')]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Command,

        [Parameter(ParameterSetName = 'Direct')]
        [switch] $Direct,

        [Parameter(ParameterSetName = 'Stream')]
        [switch] $PassThru,

        [Parameter(ParameterSetName = 'Stream')]
        [switch] $AsBytes,

        [Parameter(ParameterSetName = 'Stream')]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $TimeoutSeconds,

        [Parameter(ParameterSetName = 'Stream')]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $DrainSeconds,

        [Parameter(ParameterSetName = 'Stream')]
        [string] $InputText,

        [switch] $NoAssert,
        [switch] $Silent,
        [string] $WorkingDirectory = (Get-RepositoryRoot),
        [switch] $DryRun
    )

    # The test tripwire: a launch here means a Mock missed, almost always a wrong -ModuleName, so fail loudly.
    if (-not $DryRun -and (Test-RealProcessBlocked)) {
        throw (
            "Blocked a real process launch during a unit test: '$Command'. A Mock did not intercept it — " +
            'check the mock targets the module the calling function runs in: ' +
            'Mock <command> -ModuleName <module-of-the-function-under-test>.'
        )
    }

    Assert-PathExist $WorkingDirectory -PathType Container

    # Log the command from this function so Write-Message shows [Invoke-Executable].
    if (-not $Silent -and -not $DryRun) {
        Write-Message $Command
    }

    $params = @{
        Command          = $Command
        WorkingDirectory = $WorkingDirectory
        PassThru         = $PassThru
        NoAssert         = $NoAssert
        Silent           = $Silent
        DryRun           = $DryRun
    }

    if ($Direct) {
        Invoke-ExecutableDirect @params
    }
    else {
        if (-not $PSBoundParameters.ContainsKey('TimeoutSeconds')) {
            $TimeoutSeconds = Get-TimeoutSeconds -Executable ([Catzc.Base.Execution.CliRunner]::ExecutableName($Command))
        }
        if (-not $PSBoundParameters.ContainsKey('DrainSeconds')) {
            $DrainSeconds = (Get-Config -Config timeouts).wait['drain_seconds']
        }
        $streamed = @{ TimeoutSeconds = $TimeoutSeconds; DrainSeconds = $DrainSeconds; AsBytes = $AsBytes }
        # An unbound [string] is empty, not null, so only a passed -InputText reaches the child's stdin.
        if ($PSBoundParameters.ContainsKey('InputText')) {
            $streamed.InputText = $InputText
        }
        Invoke-ExecutableStreamed @params @streamed
    }
}
