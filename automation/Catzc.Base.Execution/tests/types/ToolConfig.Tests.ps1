<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Execution
    relatives:
      page: docs/references/automation/catzc-base-execution/tests/types/ToolConfig.Tests.ps1.md
      source: automation/Catzc.Base.Execution/types/ToolConfig.cs
    adrs:
      - ADR-AUTO-DEPS#1
      - ADR-AUTO-PKGMGR#6
      - ADR-AUTO-TEST#3
---
#>

Describe 'ToolConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:required = @{ version = '1.0'; command = 'widget'; version_command = 'widget --version'; version_pattern = '(?<ver>.+)'; winget_id = 'Widget.Widget' }
    }

    It 'maps the elevation flag <flag> from the entry' -ForEach @(
        @{ flag = 'admin_only' }
        @{ flag = 'linux_admin_only' }
    ) {
        $entry = $script:required.Clone()
        $entry[$flag] = $true
        [Catzc.Base.Execution.ToolConfig]::new($entry).$flag | Should -BeTrue
    }

    It 'defaults an absent elevation flag to false and an absent devbox_version to null' {
        $config = [Catzc.Base.Execution.ToolConfig]::new($script:required.Clone())
        $config.admin_only | Should -BeFalse
        $config.linux_admin_only | Should -BeFalse
        $config.devbox_version | Should -BeNullOrEmpty
    }

    It 'maps the devbox_version lever' {
        $entry = $script:required.Clone()
        $entry.devbox_version = '0.9'
        [Catzc.Base.Execution.ToolConfig]::new($entry).devbox_version | Should -Be '0.9'
    }

    It 'rejects an unknown key' {
        $entry = $script:required.Clone()
        $entry.gadget_id = 'x'
        { [Catzc.Base.Execution.ToolConfig]::new($entry) } | Should -Throw "*unknown key 'gadget_id'*"
    }

    It 'rejects a version_pattern without the named ver group' {
        $entry = $script:required.Clone()
        $entry.version_pattern = '^(.+)$'
        { [Catzc.Base.Execution.ToolConfig]::new($entry) } | Should -Throw '*named group (?<ver>...)*'
    }

    It 'reports whether the entry declares an install mechanism' {
        $entry = $script:required.Clone()
        [Catzc.Base.Execution.ToolConfig]::new($entry).HasInstallMechanism() | Should -BeTrue
        $entry.Remove('winget_id')
        [Catzc.Base.Execution.ToolConfig]::new($entry).HasInstallMechanism() | Should -BeFalse
    }

    It 'counts an MSYS2 package as an install mechanism and maps its URL and SHA-256' {
        $entry = $script:required.Clone()
        $entry.Remove('winget_id')
        $entry.msys2_url = 'https://example.com/widget-1.0-1-x86_64.pkg.tar.zst'
        $entry.msys2_sha256 = 'a' * 64
        $config = [Catzc.Base.Execution.ToolConfig]::new($entry)
        $config.HasInstallMechanism() | Should -BeTrue
        $config.msys2_url | Should -Be 'https://example.com/widget-1.0-1-x86_64.pkg.tar.zst'
        $config.msys2_sha256 | Should -Be ('a' * 64)
    }

    It 'defaults the MSYS2 package to null' {
        $config = [Catzc.Base.Execution.ToolConfig]::new($script:required.Clone())
        $config.msys2_url | Should -BeNullOrEmpty
        $config.msys2_sha256 | Should -BeNullOrEmpty
    }

    It 'rejects <key> declared without its partner' -Tag 'ADR-AUTO-PKGMGR#6' -ForEach @(
        @{ key = 'msys2_url'; value = 'https://example.com/widget.pkg.tar.zst' }
        @{ key = 'msys2_sha256'; value = 'a' * 64 }
    ) {
        $entry = $script:required.Clone()
        $entry[$key] = $value
        { [Catzc.Base.Execution.ToolConfig]::new($entry) } | Should -Throw '*msys2_url and msys2_sha256 are declared together*'
    }

    It 'rejects an msys2_sha256 that is not 64 lowercase hex digits: <case>' -Tag 'ADR-AUTO-PKGMGR#6' -ForEach @(
        @{ case = 'uppercase'; value = 'A' * 64 }
        @{ case = 'too short'; value = 'a' * 63 }
        @{ case = 'too long'; value = 'a' * 65 }
        @{ case = 'not hex'; value = 'g' * 64 }
        @{ case = 'trailing newline'; value = ('a' * 64) + "`n" }
    ) {
        $entry = $script:required.Clone()
        $entry.msys2_url = 'https://example.com/widget.pkg.tar.zst'
        $entry.msys2_sha256 = $value
        { [Catzc.Base.Execution.ToolConfig]::new($entry) } | Should -Throw '*must be 64 lowercase hex digits*'
    }

    It 'rejects a session_host_probes entry that does not end with {version}' {
        $entry = $script:required.Clone()
        $entry.session_host_probes = @('sdk/{version}/bin')
        { [Catzc.Base.Execution.ToolConfig]::new($entry) } | Should -Throw '*must end with the {version} segment*'
    }

    It 'declares no candidate paths when the entry has none' {
        $config = [Catzc.Base.Execution.ToolConfig]::new($script:required.Clone())
        $config.HasProbes() | Should -BeFalse
        $config.windows_probes | Should -HaveCount 0
    }

    It 'reads each candidate list into its own property' {
        $entry = $script:required.Clone()
        $entry.windows_probes = @('win-devbox')
        $entry.windows_pipeline_probes = @('win-pipeline')
        $entry.unix_probes = @('unix-devbox')
        $entry.unix_pipeline_probes = @('unix-pipeline')
        $config = [Catzc.Base.Execution.ToolConfig]::new($entry)
        $config.HasProbes() | Should -BeTrue
        $config.windows_probes | Should -Be @('win-devbox')
        $config.windows_pipeline_probes | Should -Be @('win-pipeline')
        $config.unix_probes | Should -Be @('unix-devbox')
        $config.unix_pipeline_probes | Should -Be @('unix-pipeline')
    }

    It 'counts an exclusion alone as a probed entry' {
        $entry = $script:required.Clone()
        $entry.probe_excludes = @('/gadget/widget')
        [Catzc.Base.Execution.ToolConfig]::new($entry).HasProbes() | Should -BeTrue
    }

    It 'reports every missing required key in one throw' -Tag 'ADR-AUTO-DEPS#1' {
        $err = { [Catzc.Base.Execution.ToolConfig]::new(@{ winget_id = 'Widget.Widget' }) } | Should -Throw -PassThru
        foreach ($key in 'version', 'command', 'version_command', 'version_pattern') {
            $err.Exception.Message | Should -BeLike "*$key is required*"
        }
    }
}
