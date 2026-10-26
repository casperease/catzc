function Invoke-ExecutableDirect {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '',
        Justification = 'By design — executes CLI commands')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'PassThru',
        Justification = 'Accepted for signature compatibility with other modes')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Silent',
        Justification = 'Accepted for signature compatibility with other modes')]
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

    # Output goes straight to the console, spinners included, and leaks to the pipeline unless the caller suppresses it.
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
