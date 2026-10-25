Describe 'Start-ClaudeDrone' -Tag 'L0', 'logic', 'ADR-PWSH-DRYRUN-EARLYRETURNBRANCH' {
    BeforeEach {
        $script:config = [Catzc.Tooling.Claude.ClaudeDroneConfig]::new($null)
        Mock Get-Config -ModuleName Catzc.Tooling.Claude -ParameterFilter { $Config -eq 'claude-drone' } { $script:config }
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Claude { 'C:/widget/repo' }
        Mock Start-Process -ModuleName Catzc.Tooling.Claude { }
    }

    It 'starts one drone as the configured agent in the configured terminal, in the repository root' {
        $result = @(Start-ClaudeDrone -PassThru)
        $result.Count | Should -Be 1
        $result[0] | Should -BeOfType [string]
        $result[0] | Should -BeLike "wt.exe -d `"C:/widget/repo`" new-tab *pwsh -NoExit -Command `"& claude --agent 'catzc-drone'`""
        Should -Invoke Start-Process -ModuleName Catzc.Tooling.Claude -Times 1 -Exactly -ParameterFilter { $WorkingDirectory -eq 'C:/widget/repo' -and $FilePath -eq 'wt.exe' }
    }

    It 'adds --model only when a model is given' {
        Start-ClaudeDrone -DryRun | Should -Not -BeLike '*--model*'
        Start-ClaudeDrone -DryRun -Model gadget | Should -BeLike "*--agent 'catzc-drone' --model 'gadget'*"
    }

    It 'passes the prompt as the last argument, keeping its quotes' {
        Start-ClaudeDrone -DryRun -Prompt "do the widget's work" | Should -BeLike "*--agent 'catzc-drone' 'do the widget''s work'*"
    }

    It 'starts as many drones as -Count asks for, each titled by its index' {
        $result = @(Start-ClaudeDrone -Count 3 -PassThru)
        $result.Count | Should -Be 3
        $result[2] | Should -BeLike '*--title claude-drone-3*'
        Should -Invoke Start-Process -ModuleName Catzc.Tooling.Claude -Times 3 -Exactly
    }

    It 'starts nothing and returns the command lines under -DryRun' {
        @(Start-ClaudeDrone -Count 2 -DryRun).Count | Should -Be 2
        Should -Invoke Start-Process -ModuleName Catzc.Tooling.Claude -Times 0 -Exactly
    }

    It 'returns nothing without -PassThru' {
        Start-ClaudeDrone | Should -BeNullOrEmpty
    }

    It 'takes the agent and launcher from the config, and the caller wins over it' {
        $script:config = [Catzc.Tooling.Claude.ClaudeDroneConfig]::new([ordered]@{ agent = 'gadget-agent'; launcher = 'pwsh' })
        Start-ClaudeDrone -DryRun | Should -BeExactly "pwsh -NoExit -Command `"& claude --agent 'gadget-agent'`""
        $called = Start-ClaudeDrone -DryRun -Agent widget-agent -Launcher windows-terminal
        $called | Should -BeLike 'wt.exe *'
        $called | Should -BeLike "*--agent 'widget-agent'*"
    }

    It 'escapes a semicolon for the windows terminal, which reads it as a command separator' {
        Start-ClaudeDrone -DryRun -Prompt 'one; two' | Should -BeLike "*'one\; two'*"
    }

    It 'rejects a count outside 1 to 20' {
        { Start-ClaudeDrone -Count 0 -DryRun } | Should -Throw
        { Start-ClaudeDrone -Count 21 -DryRun } | Should -Throw
    }
}
