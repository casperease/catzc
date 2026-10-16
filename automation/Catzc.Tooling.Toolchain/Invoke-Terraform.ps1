<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Toolchain/Invoke-Terraform.ps1
    name: invoke-terraform
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Tooling.Toolchain/tests/Invoke-Terraform.Tests.ps1
  config:
    synopsis: Runs terraform with the given arguments.
    description: |-
      Asserts that the installed Terraform version matches the locked version
      in Get-ToolConfig before executing the command.
    parameters:
      Arguments: Arguments to pass to terraform.
      PassThru: Return a CliResult object with Output, Errors, Full, and ExitCode.
      NoAssert: Skip exit code assertion.
      Silent: Suppress the command log line.
      DryRun: Return the command string without executing. Used for testing.
    examples:
      - Invoke-Terraform 'plan'
      - Invoke-Terraform 'plan' -DryRun
---
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
