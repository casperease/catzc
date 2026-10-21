<#
---
catzc:
  immutable:
    with_body_sha: eccbe027c08c
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-IsRunningInVSCode.Tests.ps1
    docs: "[Assert-IsRunningInVSCode.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-IsRunningInVSCode.ps1.md)"
---
#>

function Assert-IsRunningInVsCode {
    param(
        [string] $ErrorText = 'This operation requires a terminal inside VS Code'
    )

    Assert-True (Test-IsRunningInVsCode) -ErrorText $ErrorText
}
