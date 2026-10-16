<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/private/Invoke-ExecutableDirect.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Execution
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-execution/private/Invoke-ExecutableDirect.ps1.md
  config:
    synopsis: Runs a CLI command directly with no output capture or stream separation.
    description: |-
      Private implementation for Invoke-Executable -Direct.

      Output flows straight to the console as if the command were typed
      at the prompt. No buffering, no capture, no stream separation.
      Just the LASTEXITCODE lifecycle (reset, execute, assert, reset).

      -PassThru is accepted but ignored — there is nothing to return.
      Use the default (Stream) mode when you need structured output.
    parameters:
      Command: The command string to execute.
      WorkingDirectory: The directory to run the command in.
      PassThru: |-
        Accepted for signature compatibility. Ignored — Direct mode does not
        capture output.
      NoAssert: Skip the exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing.
---
#>

function Invoke-ExecutableDirect {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'By design — executes CLI commands')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'PassThru', Justification = 'Accepted for signature compatibility with other modes')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Silent', Justification = 'Accepted for signature compatibility with other modes')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Command,
        [Parameter(Mandatory)]
        [string] $WorkingDirectory,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    if ($DryRun) {
        return $Command
    }

    Reset-LastExitCode

    Push-Location $WorkingDirectory
    try {
        & {
            $ErrorActionPreference = 'Continue'
            Invoke-Expression $Command
        }
    }
    finally {
        Pop-Location
    }

    if (-not $NoAssert) {
        Assert-LastExitCodeWasZero
    }

    Reset-LastExitCode
}
