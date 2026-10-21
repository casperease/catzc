<#
---
catzc:
  immutable:
    with_body_sha: "6ff6fd6f494b"
  edges:
    docs: "[Install-Git.Tests.ps1.md](../../../docs/references/pwsh/catzc-tooling-provisioning/tests/Install-Git.Tests.ps1.md)"
    code: pwsh/Catzc.Tooling.Provisioning/Install-Git.ps1
---
#>

Describe 'Install-Git' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Invoke-RestMethod { } -ModuleName Catzc.Tooling.Provisioning
        Mock Save-VerifiedDownload { } -ModuleName Catzc.Tooling.Provisioning
        Mock Invoke-Executable { } -ModuleName Catzc.Tooling.Provisioning
        Mock Add-PermanentPath { } -ModuleName Catzc.Tooling.Provisioning
        Mock Uninstall-Git { } -ModuleName Catzc.Tooling.Provisioning
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Provisioning
        Mock Assert-IsAdministrator { } -ModuleName Catzc.Tooling.Provisioning
    }

    Context 'on Windows' {
        It 'skips the download when Git is already installed and -Force is not passed' {
            if (-not $IsWindows) {
                Set-ItResult -Skipped -Because 'windows_only_install'; return
            }
            Mock Test-Path { $true } -ModuleName Catzc.Tooling.Provisioning   # git.exe present
            { Install-Git } | Should -Not -Throw
            Should -Invoke Invoke-RestMethod -ModuleName Catzc.Tooling.Provisioning -Times 0
            Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Provisioning -Times 0
        }
    }

    Context 'on non-Windows' {
        It 'delegates installation to the platform package manager' {
            if ($IsWindows) {
                Set-ItResult -Skipped -Because 'unix_only_install'; return
            }
            Mock Test-Command { $false } -ModuleName Catzc.Tooling.Provisioning   # macOS: git absent, so it installs
            { Install-Git } | Should -Not -Throw
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 1
        }

        It 'is a no-op on Linux when git is already installed — the root assert is never reached' {
            if (-not $IsLinux) {
                Set-ItResult -Skipped -Because 'unix_only_install'; return
            }
            Mock Test-Command { $true } -ModuleName Catzc.Tooling.Provisioning
            Mock Assert-IsAdministrator { throw 'root assert must not fire for an already-installed git' } -ModuleName Catzc.Tooling.Provisioning
            { Install-Git } | Should -Not -Throw
            Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 0
        }
    }
}
