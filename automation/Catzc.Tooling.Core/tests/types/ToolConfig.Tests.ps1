Describe 'ToolConfig' -Tag 'L0', 'logic' {
    # The typed record over one tools.yml entry. It exposes only the keys it maps, so a key the record drops is
    # invisible to every caller — these pin the optional flags the provisioning loops branch on.
    BeforeAll {
        $script:required = @{ version = '1.0'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)' }
    }

    It 'maps the elevation flag <flag> from the entry' -ForEach @(
        @{ flag = 'admin_only' }
        @{ flag = 'linux_admin_only' }
    ) {
        $entry = $script:required.Clone()
        $entry[$flag] = $true
        [Catzc.Tooling.Core.ToolConfig]::new($entry).$flag | Should -BeTrue
    }

    It 'defaults an absent elevation flag to false' {
        $config = [Catzc.Tooling.Core.ToolConfig]::new($script:required.Clone())
        $config.admin_only | Should -BeFalse
        $config.linux_admin_only | Should -BeFalse
    }
}
