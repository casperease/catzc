<#
---
catzc:
  immutable:
    with_body_sha: "8abdae51de96"
  edges:
    code: pwsh/Catzc.Tooling.Toolchain/Uninstall-AzCli.ps1
    cites:
      - ADR-AUTO-REMOVE-DOUBLYGUARDED
      - ADR-AUTO-REMOVE-ONECALLESCALATION
---
#>

Describe 'Uninstall-AzCli' -Tag 'L1', 'logic' {
    BeforeEach {
        Mock Uninstall-UvVenvTool { } -ModuleName Catzc.Tooling.Toolchain
        Mock Remove-AzCli { } -ModuleName Catzc.Tooling.Toolchain
        Mock Write-Message { } -ModuleName Catzc.Tooling.Toolchain
    }

    It 'runs the managed uninstall only, by default' {
        Uninstall-AzCli
        Should -Invoke Uninstall-UvVenvTool -ModuleName Catzc.Tooling.Toolchain -Times 1
        Should -Invoke Remove-AzCli -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'escalates to Remove-AzCli -Force after the managed uninstall with -Remove -Force' -Tag 'ADR-AUTO-REMOVE-ONECALLESCALATION' {
        Uninstall-AzCli -Remove -Force
        Should -Invoke Uninstall-UvVenvTool -ModuleName Catzc.Tooling.Toolchain -Times 1
        Should -Invoke Remove-AzCli -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Force -eq $true }
    }

    It 'escalates as a dry-run — Remove-AzCli without -Force — when -Remove has no -Force' -Tag 'ADR-AUTO-REMOVE-DOUBLYGUARDED' {
        Uninstall-AzCli -Remove
        Should -Invoke Remove-AzCli -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { -not $Force }
    }

    It 'still evicts when the managed uninstall fails — the case -Remove exists for' -Tag 'ADR-AUTO-REMOVE-ONECALLESCALATION' {
        Mock Uninstall-UvVenvTool { throw 'the manager cannot find this install' } -ModuleName Catzc.Tooling.Toolchain
        Uninstall-AzCli -Remove -Force
        Should -Invoke Remove-AzCli -ModuleName Catzc.Tooling.Toolchain -Times 1 -ParameterFilter { $Force -eq $true }
    }
}
