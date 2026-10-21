<#
---
catzc:
  immutable:
    with_body_sha: ff9700213945
  edges:
    test: pwsh/Catzc.Base.Execution/tests/Reset-LastExitCode.Tests.ps1
    docs: "[Reset-LastExitCode.ps1.md](../../docs/references/pwsh/catzc-base-execution/Reset-LastExitCode.ps1.md)"
---
#>

function Reset-LastExitCode {
    param()

    $exitVar = Get-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore
    if ($exitVar) {
        Remove-Variable LASTEXITCODE -Scope Global
    }
}
