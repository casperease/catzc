<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-execution/Reset-LastExitCode.ps1.md"
  header: "generated"
---
#>

function Reset-LastExitCode {
    param()

    $exitVar = Get-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore
    if ($exitVar) {
        Remove-Variable LASTEXITCODE -Scope Global
    }
}
