<#
---
catzc:
  immutable:
    with_body_sha: da1c5ea4ad97
  edges:
    docs: "[Invoke-ExecutableStreamed.ps1.md](../../../docs/references/pwsh/catzc-base-execution/private/Invoke-ExecutableStreamed.ps1.md)"
---
#>

function Invoke-ExecutableStreamed {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'By design — executes CLI commands')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns string in -DryRun, Catzc.Base.Execution.CliResult in -PassThru')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning (set by Test-Automation) is read to suppress streamed child output during test runs; global is required to cross module session-state boundaries')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Command,
        [Parameter(Mandatory)]
        [string] $WorkingDirectory,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $TimeoutSeconds,
        [switch] $AsBytes,
        [string] $InputText,
        [switch] $DryRun
    )

    if ($DryRun) {
        return $Command
    }

    Reset-LastExitCode

    $suppressOutput = [bool]$Silent -or [bool](Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore)

    # CliRunner is autoloaded at import time from types/ (Bootstrap's Import-CSharpTypes).
    try {
        $runResult = if ($AsBytes) {
            [Catzc.Base.Execution.CliRunner]::RunBytes($Command, $WorkingDirectory, $TimeoutSeconds)
        }
        else {
            # Null leaves stdin as before; a bound -InputText, even an empty one, is written and closed.
            $standardInput = if ($PSBoundParameters.ContainsKey('InputText')) {
                $InputText
            }
            else {
                $null
            }
            [Catzc.Base.Execution.CliRunner]::Run($Command, $suppressOutput, $WorkingDirectory, $TimeoutSeconds, $standardInput)
        }
    }
    catch [System.Management.Automation.MethodInvocationException] {
        # A .NET method call wraps what it throws; surface the runner's own error (e.g. the TimeoutException).
        throw $_.Exception.InnerException
    }

    # Set $LASTEXITCODE so Assert-LastExitCodeWasZero works
    $global:LASTEXITCODE = $runResult.ExitCode

    if (-not $NoAssert) {
        Assert-LastExitCodeWasZero
    }

    Reset-LastExitCode

    if ($AsBytes) {
        [Catzc.Base.Execution.CliResult]::new([byte[]] $runResult.StdoutBytes, $runResult.Stderr, $runResult.ExitCode)
    }
    elseif ($PassThru) {
        # The CliResult constructor owns the derivation (trim, merge, split) — see types/CliResult.cs.
        [Catzc.Base.Execution.CliResult]::new($runResult.Stdout, $runResult.Stderr, $runResult.ExitCode)
    }
}
