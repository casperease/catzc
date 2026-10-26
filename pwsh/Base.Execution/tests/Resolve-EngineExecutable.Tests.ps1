<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-execution/tests/Resolve-EngineExecutable.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Resolve-EngineExecutable' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('bash', 'C:\widget\bin\bash.exe', 'probe', '5.2.37',
            '5', $true, 1, 0, 'Agent')
        $script:zshProbe = [Catzc.Base.Execution.ExecutableProbe]::new('zsh', 'C:\widget\bin\zsh.exe', 'probe', '5.9',
            '5', $true, 1, 0, 'Agent')
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Execution -ParameterFilter { $Tool -eq 'bash' } { $script:probe }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Execution -ParameterFilter { $Tool -eq 'zsh' } { $script:zshProbe }
    }

    It 'locates pwsh beside the running PowerShell, never through PATH' {
        Resolve-EngineExecutable -Engine pwsh | Should -Be (Join-Path $PSHOME ($IsWindows ? 'pwsh.exe' : 'pwsh'))
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Execution -Times 0
    }

    It 'locates bash through its tools.yml entry' {
        Resolve-EngineExecutable -Engine bash | Should -Be 'C:\widget\bin\bash.exe'
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter { $Tool -eq 'bash' }
    }

    It 'locates zsh through its tools.yml entry, as bash' {
        Resolve-EngineExecutable -Engine zsh | Should -Be 'C:\widget\bin\zsh.exe'
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.Execution -Times 1 -Exactly -ParameterFilter { $Tool -eq 'zsh' }
    }

    It 'throws, naming the engine, when bash is not found' {
        $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('bash', $null, 'none', $null, '5', $false, 1, 0,
            'Agent')
        { Resolve-EngineExecutable -Engine bash } | Should -Throw "*bash engine's executable was not found*"
    }

    It 'throws, naming the engine, when zsh is not found' {
        $script:zshProbe = [Catzc.Base.Execution.ExecutableProbe]::new('zsh', $null, 'none', $null, '5', $false, 1, 0,
            'Agent')
        { Resolve-EngineExecutable -Engine zsh } |
            Should -Throw "*zsh engine's executable was not found (tools.yml entry 'zsh')*"
    }

    It 'throws when bash misses its pin' {
        $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('bash', 'C:\widget\bin\bash.exe', 'probe', '4.4.0',
            '5', $false, 1, 0, 'Agent')
        { Resolve-EngineExecutable -Engine bash } | Should -Throw "*reports version '4.4.0', but tools.yml pins '5'*"
    }

    It 'throws for a name that is not an engine' {
        { Resolve-EngineExecutable -Engine widget } | Should -Throw '*not an execution engine*'
    }
}
