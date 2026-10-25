<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-core/tests/Write-ToolProbeReport.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Write-ToolProbeReport' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Write-Message { } -ModuleName Catzc.Tooling.Core
        $script:found = [Catzc.Base.Execution.ExecutableProbe]::new('widget', '/opt/widget/bin/widget', 'probe', '5.2.37', '5', $true, 4, 150, 'Agent')
        $script:missing = [Catzc.Base.Execution.ExecutableProbe]::new('gadget', $null, 'none', $null, '1.27', $false, 2, 0, 'Agent')
    }

    It 'renders a header row and one row per tool, with every field' {
        $script:found, $script:missing | Write-ToolProbeReport
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 1 -Exactly -ParameterFilter {
            $lines = $Message -split [Environment]::NewLine
            $NoHeader -and
            $lines.Count -eq 4 -and
            $lines[0] -eq 'Tool checks (actor: Agent)' -and
            $lines[1] -match '^Tool\s+Found\s+Method\s+Version\s+Required\s+VersionOk\s+ProbeMs\s+VersionMs\s+Path$' -and
            $lines[2] -match '^widget\s+True\s+probe\s+5\.2\.37\s+5\s+True\s+4\s+150\s+/opt/widget/bin/widget$' -and
            $lines[3] -match '^gadget\s+False\s+none\s+-\s+1\.27\s+False\s+2\s+0\s+-$'
        }
    }

    It 'aligns the columns' {
        Write-ToolProbeReport -Probe $script:found, $script:missing
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 1 -Exactly -ParameterFilter {
            $lines = $Message -split [Environment]::NewLine
            $lines[1].IndexOf('Found') -eq $lines[2].IndexOf('True') -and $lines[1].IndexOf('Found') -eq $lines[3].IndexOf('False')
        }
    }

    It 'checks every tool in tools.yml when called with no arguments' {
        Mock Get-Config { [pscustomobject]@{ Keys = @('widget', 'gadget') } } -ModuleName Catzc.Tooling.Core -ParameterFilter { $Config -eq 'tools' }
        Mock Test-Tool {
            if ($Tool -eq 'widget') {
                $script:found
            }
            else {
                $script:missing
            }
        } -ModuleName Catzc.Tooling.Core
        Write-ToolProbeReport
        Should -Invoke Test-Tool -ModuleName Catzc.Tooling.Core -Times 2 -Exactly -ParameterFilter { $PassThru }
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 1 -Exactly -ParameterFilter { ($Message -split [Environment]::NewLine).Count -eq 4 }
    }

    It 'writes nothing for no records' {
        @() | Write-ToolProbeReport
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Core -Times 0 -Exactly
    }
}
