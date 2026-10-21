<#
---
catzc:
  immutable:
    with_body_sha: "0e16ef79acb0"
  edges:
    test: pwsh/Catzc.Azure.DevOps/tests/ConvertFrom-AdoPipelineCommand.Tests.ps1
    docs: "[ConvertFrom-AdoPipelineCommand.ps1.md](../../docs/references/pwsh/catzc-azure-dev-ops/ConvertFrom-AdoPipelineCommand.ps1.md)"
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
