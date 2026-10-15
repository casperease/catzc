<#
.SYNOPSIS
    Sanitizes a command string received from an ADO pipeline step.
.DESCRIPTION
    YAML is already parsed by now, so only the plain string is cleaned, never YAML syntax.
    [comment:1](/docs/references/automation/catzc-azure-devops/ConvertFrom-AdoPipelineCommand.ps1.md#comment1)
.PARAMETER Command
    The raw command string as received from ADO pipeline arguments.
.EXAMPLE
    ConvertFrom-AdoPipelineCommand "  Get-Process `r`n  Get-Service  "
    # Returns: "Get-Process\nGet-Service"
.EXAMPLE
    # In Invoke-AdoScript.ps1:
    $sanitized = ConvertFrom-AdoPipelineCommand $Command
    $block = [ScriptBlock]::Create($sanitized)
    Invoke-Command -ScriptBlock $block -NoNewScope
#>
function ConvertFrom-AdoPipelineCommand {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Command
    )

    # Normalize line endings: \r\n → \n, stray \r → \n
    $clean = $Command -replace "`r`n", "`n"
    $clean = $clean -replace "`r", "`n"

    # Trim leading/trailing whitespace and blank lines
    $clean = $clean.Trim()

    # Remove trailing whitespace per line (YAML indentation artifacts)
    $clean = ($clean -split "`n" | ForEach-Object { $_.TrimEnd() }) -join "`n"

    $clean
}
