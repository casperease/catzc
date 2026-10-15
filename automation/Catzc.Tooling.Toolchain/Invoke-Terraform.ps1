<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Invoke-Terraform.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Runs terraform with the given arguments.
.DESCRIPTION
    A drifted Terraform fails the assertion before the command starts, so no plan or apply runs on another version.
.PARAMETER Arguments
    Arguments to pass to terraform.
.PARAMETER PassThru
    Return a CliResult object with Output, Errors, Full, and ExitCode.
.PARAMETER NoAssert
    Skip exit code assertion.
.PARAMETER Silent
    Suppress the command log line.
.PARAMETER DryRun
    Return the command string without executing. Used for testing.
.EXAMPLE
    Invoke-Terraform 'plan'
.EXAMPLE
    Invoke-Terraform 'plan' -DryRun
#>
function Invoke-Terraform {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Arguments,
        [switch] $PassThru,
        [switch] $NoAssert,
        [switch] $Silent,
        [switch] $DryRun
    )

    if (-not $DryRun) {
        Assert-Tool 'terraform'
    }

    Invoke-Executable "terraform $Arguments" -PassThru:$PassThru -NoAssert:$NoAssert -Silent:$Silent -DryRun:$DryRun
}
