<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-IsRunningInVSCode.ps1.md"
  warning: "Generated Header"
---
#>

function Assert-IsRunningInVsCode {
    param(
        [string] $ErrorText = 'This operation requires a terminal inside VS Code'
    )

    Assert-True (Test-IsRunningInVsCode) -ErrorText $ErrorText
}
