<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1
    folder: tests/types
    name: executable-probe-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-execution/tests/types/ExecutableProbe.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
---
#>

Describe 'ExecutableProbe' -Tag 'L0', 'logic' {

    It 'reads a found executable as Found with its path' {
        $probe = [Catzc.Base.Execution.ExecutableProbe]::new('widget', '/opt/widget/bin/widget', 'probe', '2.1.0', '2', $true, 3, 120, 'Person')
        $probe.Name | Should -Be 'widget'
        $probe.Found | Should -BeTrue
        $probe.Path | Should -Be '/opt/widget/bin/widget'
        $probe.VersionOk | Should -BeTrue
        $probe.ProbeMs | Should -Be 3
        $probe.VersionMs | Should -Be 120
        $probe.Actor | Should -Be 'Person'
    }

    It 'reads a missing executable as not Found, with no path or version' {
        $probe = [Catzc.Base.Execution.ExecutableProbe]::new('widget', $null, 'none', '', '2', $false, 1, 0, 'Pipeline')
        $probe.Found | Should -BeFalse
        $probe.Path | Should -BeNullOrEmpty
        $probe.Version | Should -BeNullOrEmpty
    }

    It 'rejects an unknown method' {
        { [Catzc.Base.Execution.ExecutableProbe]::new('widget', '/w', 'guess', $null, '2', $false, 0, 0, 'Person') } |
            Should -Throw '*must be one of*'
    }

    It 'rejects a method that disagrees with the path' {
        { [Catzc.Base.Execution.ExecutableProbe]::new('widget', $null, 'path', $null, '2', $false, 0, 0, 'Person') } |
            Should -Throw '*does not agree*'
        { [Catzc.Base.Execution.ExecutableProbe]::new('widget', '/w', 'none', $null, '2', $false, 0, 0, 'Person') } |
            Should -Throw '*does not agree*'
    }

    It 'requires the name' {
        { [Catzc.Base.Execution.ExecutableProbe]::new('', '/w', 'probe', $null, '2', $false, 0, 0, 'Person') } |
            Should -Throw '*Name is required*'
    }
}
