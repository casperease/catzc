Describe 'Get-ToolsStatus' -Tag 'L0', 'logic' {
    # The probed branch: a tool with candidate paths takes its location and version from the probe record
    # (Test-Tool -PassThru) and never starts a version job on its bare name. The probe, the package-manager oracle,
    # the scope and winget are mocked. Fixture tokens are neutral
    # ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
    BeforeAll {
        $script:tools = [Catzc.Tooling.Core.ToolsConfig]::new([ordered]@{
                widget = @{
                    version = '5'; command = 'widget'; system_provided = $true; version_command = 'widget --version'
                    version_pattern = 'version (?<ver>[\d.]+)'; unix_probes = @('/opt/widget'); windows_probes = @('C:\widget.exe')
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
}
