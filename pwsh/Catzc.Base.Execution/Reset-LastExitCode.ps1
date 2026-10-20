<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Execution/Reset-LastExitCode.ps1
    name: reset-last-exit-code
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Execution/tests/Reset-LastExitCode.Tests.ps1
    docs: "[Reset-LastExitCode.ps1.md](docs/references/pwsh/catzc-base-execution/Reset-LastExitCode.ps1.md)"
---
#>

function Reset-LastExitCode {
    param()

    $exitVar = Get-Variable LASTEXITCODE -Scope Global -ErrorAction Ignore
    if ($exitVar) {
        Remove-Variable LASTEXITCODE -Scope Global
    }
}
