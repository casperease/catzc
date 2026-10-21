<#
---
catzc:
  immutable:
    with_body_sha: "793b01eddf73"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-IsRunningInVSCode.Tests.ps1
    docs: "[Assert-IsRunningInVSCode.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-IsRunningInVSCode.ps1.md)"
---
#>

function Assert-IsRunningInVSCode {
    param(
        [string] $ErrorText = 'This operation requires a terminal inside VS Code'
    )

    Assert-True (Test-IsRunningInVSCode) -ErrorText $ErrorText
}
