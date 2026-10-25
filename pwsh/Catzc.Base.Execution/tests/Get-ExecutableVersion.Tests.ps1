<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-execution/tests/Get-ExecutableVersion.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Get-ExecutableVersion' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Invoke-Executable { [Catzc.Base.Execution.CliResult]::new('widget version 5.2.37', '', 0) } -ModuleName Catzc.Base.Execution
    }

    It 'runs the located path with the arguments and returns the captured version' {
        InModuleScope Catzc.Base.Execution {
            Get-ExecutableVersion -Path '/opt/widget/bin/widget' -Arguments '--version' -Pattern 'version (?<ver>[\d.]+)' | Should -Be '5.2.37'
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $Command -eq '"/opt/widget/bin/widget" --version' -and $PassThru -and $NoAssert -and $Silent
        }
    }

    It 'runs in the executable''s own folder, so no project file in the repository changes the answer' {
        InModuleScope Catzc.Base.Execution {
            Get-ExecutableVersion -Path '/opt/widget/bin/widget' -Arguments '--version' -Pattern 'version (?<ver>[\d.]+)' | Out-Null
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter {
            $WorkingDirectory -eq [System.IO.Path]::GetDirectoryName('/opt/widget/bin/widget')
        }
    }

    It 'runs the path alone when there are no arguments' {
        InModuleScope Catzc.Base.Execution {
            Get-ExecutableVersion -Path '/opt/widget/bin/widget' -Pattern 'version (?<ver>[\d.]+)' | Out-Null
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter { $Command -eq '"/opt/widget/bin/widget"' }
    }

    It 'returns null when the output does not match' {
        InModuleScope Catzc.Base.Execution {
            Get-ExecutableVersion -Path '/opt/widget/bin/widget' -Arguments '--version' -Pattern 'gadget (?<ver>[\d.]+)' | Should -BeNullOrEmpty
        }
    }
}
