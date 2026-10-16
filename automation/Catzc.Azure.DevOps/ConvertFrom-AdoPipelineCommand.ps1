<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.DevOps/ConvertFrom-AdoPipelineCommand.ps1
    name: convert-from-ado-pipeline-command
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.DevOps/tests/ConvertFrom-AdoPipelineCommand.Tests.ps1
  config:
    synopsis: Sanitizes a command string received from an ADO pipeline step.
    description: |-
      When ADO passes a command string through YAML template parameters, task
      arguments, and into PowerShell, the string accumulates escaping artifacts:
      carriage returns from Windows line endings, mixed newlines depending on
      whether the source YAML used folding (>) or literal (|) block scalars,
      and trailing whitespace from YAML indentation. By the time the string
      reaches PowerShell, YAML has already been parsed — this function only
      deals with the resulting plain string, not YAML syntax.

      This function normalizes the string for safe use with [ScriptBlock]::Create().
    parameters:
      Command: The raw command string as received from ADO pipeline arguments.
    examples:
      - |-
        ConvertFrom-AdoPipelineCommand "  Get-Process `r`n  Get-Service  "
        # Returns: "Get-Process\nGet-Service"
      - |-
        # In Invoke-AdoScript.ps1:
        $sanitized = ConvertFrom-AdoPipelineCommand $Command
        $block = [ScriptBlock]::Create($sanitized)
        Invoke-Command -ScriptBlock $block -NoNewScope
---
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
