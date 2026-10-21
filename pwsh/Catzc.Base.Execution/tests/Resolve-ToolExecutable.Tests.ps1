<#
---
catzc:
  immutable:
    with_body_sha: b40247570243
  edges:
    docs: "[Resolve-ToolExecutable.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-execution/tests/Resolve-ToolExecutable.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Execution/Resolve-ToolExecutable.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

Describe 'Resolve-ToolExecutable' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:windows = [bool]$IsWindows
        $script:tools = @{
            widget = @{
                version                 = '5'
                devbox_version          = '4.4'
                command                 = 'widget-cli'
                version_command         = 'widget-cli --version --short'
                version_pattern         = 'version (?<ver>[\d.]+)'
                windows_probes          = @('C:\widget\user.exe', 'C:\widget\machine.exe')
                windows_pipeline_probes = @('C:\widget\agent.exe')
                unix_probes             = @('/opt/widget/user', '/usr/bin/widget')
                unix_pipeline_probes    = @('/opt/widget/agent')
                probe_excludes          = @('C:\widget\wsl.exe')
            }
            gadget = @{
                version         = '1.27'
                command         = 'gadget'
                version_command = 'gadget version'
                version_pattern = 'go(?<ver>[\d.]+)'
            }
        }
    }
    BeforeEach {
        Mock Get-Config { $script:tools } -ModuleName Catzc.Base.Execution -ParameterFilter { $Config -eq 'tools' }
        Mock Get-RunEnvironment { 'Devbox' } -ModuleName Catzc.Base.Execution
        Mock Find-Executable { [Catzc.Base.Execution.ExecutableProbe]::new($Name, '/opt/widget/user', 'probe', '5.2', $RequiredVersion, $true, 1, 1, 'Person') } -ModuleName Catzc.Base.Execution
    }

    It 'returns the probe record named by the tool key' {
        $probe = Resolve-ToolExecutable -Tool widget
        $probe | Should -BeOfType [Catzc.Base.Execution.ExecutableProbe]
        $probe.Name | Should -Be 'widget'
        $probe.Path | Should -Be '/opt/widget/user'
    }

    It 'hands over the command, the version arguments without the executable token, the pattern and the pin' {
        Resolve-ToolExecutable -Tool widget | Out-Null
        Should -Invoke Find-Executable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'widget' -and $Command -eq 'widget-cli' -and $VersionArguments -eq '--version --short' -and
            $VersionPattern -eq 'version (?<ver>[\d.]+)' -and $RequiredVersion -eq '5' -and
            ($Exclude -join '|') -eq 'C:\widget\wsl.exe'
        }
    }

    It 'hands a devbox the devbox list and the devbox_version lever' {
        $expected = if ($script:windows) {
            'C:\widget\user.exe|C:\widget\machine.exe'
        }
        else {
            '/opt/widget/user|/usr/bin/widget'
        }
        Resolve-ToolExecutable -Tool widget | Out-Null
        Should -Invoke Find-Executable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            ($Candidate -join '|') -eq $expected -and ($AcceptVersion -join '|') -eq '4.4'
        }
    }

    It 'hands a pipeline the pipeline list, without the devbox_version lever' {
        Mock Get-RunEnvironment { 'Pipeline' } -ModuleName Catzc.Base.Execution
        $expected = if ($script:windows) {
            'C:\widget\agent.exe'
        }
        else {
            '/opt/widget/agent'
        }
        Resolve-ToolExecutable -Tool widget | Out-Null
        Should -Invoke Find-Executable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            ($Candidate -join '|') -eq $expected -and $AcceptVersion.Count -eq 0
        }
    }

    It 'locates an entry without candidate paths on PATH alone' {
        Resolve-ToolExecutable -Tool gadget | Out-Null
        Should -Invoke Find-Executable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Candidate.Count -eq 0 -and $Exclude.Count -eq 0 -and $AcceptVersion.Count -eq 0 -and $VersionArguments -eq 'version'
        }
    }

    It 'throws for a tool tools.yml does not declare' {
        { Resolve-ToolExecutable -Tool sprocket } | Should -Throw "*Tool 'sprocket' is not declared in tools.yml*"
    }
}

Describe 'Resolve-ToolExecutable on the shipped bash entry' -Tag 'L0', 'integrity' {
    # The shipped tools.yml bash entry, read for real: the WSL launcher never counts as bash.
    BeforeEach {
        InModuleScope Catzc.Base.Execution { $script:executableVersionCache = $null }
        Mock Get-RunEnvironment { 'Devbox' } -ModuleName Catzc.Base.Execution
        Mock Get-ExecutableVersion { '5.2.37' } -ModuleName Catzc.Base.Execution
    }

    It 'excludes the WSL launcher' {
        (Get-Config -Config tools)['bash']['probe_excludes'] | Should -Contain '%SystemRoot%\System32\bash.exe'
    }

    It 'never reads the WSL launcher on PATH as bash (Windows)' {
        if (-not $IsWindows) {
            Set-ItResult -Skipped -Because 'windows_only_wsl_launcher'
            return
        }
        $wsl = Join-Path $env:SystemRoot 'System32\bash.exe'
        Mock Test-Path { $false } -ModuleName Catzc.Base.Execution -ParameterFilter { $PathType -eq 'Leaf' }
        Mock Get-Command { [pscustomobject]@{ Source = $wsl } } -ModuleName Catzc.Base.Execution -ParameterFilter { $CommandType -eq 'Application' }
        $probe = Resolve-ToolExecutable -Tool bash
        $probe.Found | Should -BeFalse
        Should -Invoke Get-ExecutableVersion -ModuleName Catzc.Base.Execution -Times 0 -Exactly
    }
}
