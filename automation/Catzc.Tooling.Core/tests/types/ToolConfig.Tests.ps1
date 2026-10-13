Describe 'ToolConfig' -Tag 'L0', 'logic' {
    # The typed record over one tools.yml entry. It rejects keys it does not map (a dropped key would be invisible
    # to every caller), and these pin the optional flags the provisioning loops branch on. Fixture tokens are
    # neutral ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
    BeforeAll {
        $script:required = @{ version = '1.0'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)'; winget_id = 'Widget.Widget' }
    }

    It 'maps the elevation flag <flag> from the entry' -ForEach @(
        @{ flag = 'admin_only' }
        @{ flag = 'linux_admin_only' }
    ) {
        $entry = $script:required.Clone()
        $entry[$flag] = $true
        [Catzc.Tooling.Core.ToolConfig]::new($entry).$flag | Should -BeTrue
    }

    It 'defaults an absent elevation flag to false and an absent devbox_version to null' {
        $config = [Catzc.Tooling.Core.ToolConfig]::new($script:required.Clone())
        $config.admin_only | Should -BeFalse
        $config.linux_admin_only | Should -BeFalse
        $config.devbox_version | Should -BeNullOrEmpty
    }

    It 'maps the devbox_version lever' {
        $entry = $script:required.Clone()
        $entry.devbox_version = '0.9'
        [Catzc.Tooling.Core.ToolConfig]::new($entry).devbox_version | Should -Be '0.9'
    }

    It 'rejects an unknown key' {
        $entry = $script:required.Clone()
        $entry.gadget_id = 'x'
        { [Catzc.Tooling.Core.ToolConfig]::new($entry) } | Should -Throw "*unknown key 'gadget_id'*"
    }

    It 'rejects a version_pattern without the named ver group' {
        $entry = $script:required.Clone()
        $entry.version_pattern = '^(.+)$'
        { [Catzc.Tooling.Core.ToolConfig]::new($entry) } | Should -Throw '*named group (?<ver>...)*'
    }

    It 'reports whether the entry declares an install mechanism' {
        $entry = $script:required.Clone()
        [Catzc.Tooling.Core.ToolConfig]::new($entry).HasInstallMechanism() | Should -BeTrue
        $entry.Remove('winget_id')
        [Catzc.Tooling.Core.ToolConfig]::new($entry).HasInstallMechanism() | Should -BeFalse
    }

    It 'rejects a session_host_probes entry that does not end with {version}' {
        $entry = $script:required.Clone()
        $entry.session_host_probes = @('sdk/{version}/bin')
        { [Catzc.Tooling.Core.ToolConfig]::new($entry) } | Should -Throw '*must end with the {version} segment*'
    }

    It 'reports every missing required key in one throw' -Tag 'ADR-AUTO-DEPS#1' {
        $err = { [Catzc.Tooling.Core.ToolConfig]::new(@{ winget_id = 'Widget.Widget' }) } | Should -Throw -PassThru
        foreach ($key in 'version', 'command', 'version_command', 'version_pattern') {
            $err.Exception.Message | Should -BeLike "*$key is required*"
        }
    }
}
