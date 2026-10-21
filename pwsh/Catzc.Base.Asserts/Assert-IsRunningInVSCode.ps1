<#
---
catzc:
  immutable:
    with_body_sha: "793b01eddf73"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-IsRunningInVsCode.Tests.ps1
    docs: "[Assert-IsRunningInVsCode.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-IsRunningInVsCode.ps1.md)"
---
#>

function Assert-IsRunningInVsCode {
    param(
        [string] $ErrorText = 'This operation requires a terminal inside VS Code'
    )

    Assert-True (Test-IsRunningInVsCode) -ErrorText $ErrorText
}
