<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-tooling-provisioning/tests/Get-ToolsStatus.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-ToolsStatus' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:tools = [Catzc.Base.Execution.ToolsConfig]::new([ordered]@{
                widget = @{
                    version = '5'; command = 'widget'; system_provided = $true; version_command = 'widget --version'
                    version_pattern = 'version (?<ver>[\d.]+)'; unix_probes = @('/opt/widget'); windows_probes = @('C:\widget.exe')
                }
            })
        $script:twoMechanismTools = [Catzc.Base.Execution.ToolsConfig]::new([ordered]@{
                gadget = @{
                    version = '5'; command = 'gadget'; version_command = 'gadget --version'; version_pattern = 'gadget (?<ver>[\d.]+)'
                    msys2_url = 'https://example.com/gadget-5.0-1-x86_64.pkg.tar.zst'; msys2_sha256 = 'b' * 64; windows_install_dir = 'Widget'
                    apt_package = 'gadget-pkg'; unix_probes = @('/opt/gadget'); windows_probes = @('C:\gadget.exe')
                }
            })
    }
    BeforeEach {
        Mock Get-Config { $script:tools } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Config -eq 'tools' }
        Mock Test-Command { $false } -ModuleName Catzc.Tooling.Provisioning
        Mock Start-ThreadJob { throw 'no version job may start for a probed tool' } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-ExpectedPackageManager { $true } -ModuleName Catzc.Tooling.Provisioning
        Mock Get-InstallScope { 'user' } -ModuleName Catzc.Tooling.Provisioning
        Mock Write-Message { } -ModuleName Catzc.Tooling.Provisioning
    }

    It 'reports a found probed tool from the probe record' {
        Mock Test-Tool { [Catzc.Base.Execution.ExecutableProbe]::new('widget', '/opt/widget', 'probe', '5.2.37', '5', $true, 1, 1, 'Person') } -ModuleName Catzc.Tooling.Provisioning
        $status = Get-ToolsStatus
        $status.Tool | Should -Be 'widget'
        "$($status.Status)" | Should -Be 'OK'
        $status.Location | Should -Be '/opt/widget'
        $status.Installed | Should -Be '5.2.37'
        $status.Manager | Should -Be 'system'
    }

    It 'reports a missing platform-provided tool with the platform remedy' {
        Mock Test-Tool { [Catzc.Base.Execution.ExecutableProbe]::new('widget', $null, 'none', $null, '5', $false, 1, 0, 'Person') } -ModuleName Catzc.Tooling.Provisioning
        $status = Get-ToolsStatus
        "$($status.Status)" | Should -Be 'Missing'
        $status.Action | Should -BeLike 'Provided by the platform*'
    }

    It 'reports an MSYS2-package tool under the msys2 manager on Windows and the system elsewhere, judged at its probe path' {
        $msys2Tools = [Catzc.Base.Execution.ToolsConfig]::new([ordered]@{
                gadget = @{
                    version = '5'; command = 'gadget'; version_command = 'gadget --version'; version_pattern = 'gadget (?<ver>[\d.]+)'
                    msys2_url = 'https://example.com/gadget-5.0-1-x86_64.pkg.tar.zst'; msys2_sha256 = 'b' * 64; windows_install_dir = 'Widget'
                    unix_probes = @('/opt/gadget'); windows_probes = @('C:\gadget.exe')
                }
            })
        Mock Get-Config { $msys2Tools } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Config -eq 'tools' }
        Mock Test-Tool { [Catzc.Base.Execution.ExecutableProbe]::new('gadget', '/opt/gadget', 'probe', '5.9', '5', $true, 1, 1, 'Person') } -ModuleName Catzc.Tooling.Provisioning
        $status = Get-ToolsStatus
        "$($status.Status)" | Should -Be 'OK'
        $status.Manager | Should -Be ($IsWindows ? 'msys2' : 'system')
        Should -Invoke Test-ExpectedPackageManager -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly -ParameterFilter { $Path -eq '/opt/gadget' }
    }

    It 'reports an MSYS2-package tool that declares an apt package under the manager of the running platform' {
        Mock Get-Config { $script:twoMechanismTools } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Config -eq 'tools' }
        Mock Test-Tool { [Catzc.Base.Execution.ExecutableProbe]::new('gadget', '/opt/gadget', 'probe', '5.9', '5', $true, 1, 1, 'Person') } -ModuleName Catzc.Tooling.Provisioning
        $expected = if ($IsWindows) {
            'msys2'
        }
        elseif ($IsLinux) {
            'apt'
        }
        else {
            'system'
        }
        $status = Get-ToolsStatus
        "$($status.Status)" | Should -Be 'OK'
        $status.Manager | Should -Be $expected
    }

    It 'names the installer, not the platform, for a missing MSYS2-package tool where it declares a manager' {
        Mock Get-Config { $script:twoMechanismTools } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Config -eq 'tools' }
        Mock Test-Tool { [Catzc.Base.Execution.ExecutableProbe]::new('gadget', $null, 'none', $null, '5', $false, 1, 0, 'Person') } -ModuleName Catzc.Tooling.Provisioning
        $status = Get-ToolsStatus
        "$($status.Status)" | Should -Be 'Missing'
        $status.Action | Should -Be ($IsMacOS ? 'Provided by the platform, not the toolchain — install it (bash on Windows: Install-Git)' : 'Run Install-Gadget')
    }
}
