Describe 'Start-ClaudeDrone' -Tag 'L0', 'logic', 'ADR-PWSH-DRYRUN-EARLYRETURNBRANCH' {
    BeforeEach {
        $script:config = [Catzc.Tooling.Claude.ClaudeDroneConfig]::new($null)
        Mock Get-Config -ModuleName Catzc.Tooling.Claude -ParameterFilter { $Config -eq 'claude-drone' } { $script:config }
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Claude { 'C:/widget/repo' }
        Mock Resolve-ClaudeSkillDrone -ModuleName Catzc.Tooling.Claude { 'drone-sonnet' }
        Mock Start-Process -ModuleName Catzc.Tooling.Claude { }
    }

    It 'starts one drone as the skill floor''s drone in the configured terminal, in the repository root' {
        $result = @(Start-ClaudeDrone -Skill widget-spin -PassThru)
        $result.Count | Should -Be 1
        $result[0] | Should -BeOfType [string]
        $result[0] |
            Should -BeLike "wt.exe -d `"C:/widget/repo`" new-tab *pwsh -NoExit -Command `"& claude --agent 'drone-sonnet' 'skill: widget-spin'`""
        Should -Invoke Start-Process -ModuleName Catzc.Tooling.Claude -Times 1 -Exactly -ParameterFilter { $WorkingDirectory -eq 'C:/widget/repo' -and $FilePath -eq 'wt.exe' }
        Should -Invoke Resolve-ClaudeSkillDrone -ModuleName Catzc.Tooling.Claude -Times 1 -Exactly -ParameterFilter { $Skill -eq 'widget-spin' }
    }

    It 'adds --model only when a model is given' {
        Start-ClaudeDrone -Skill widget-spin -DryRun | Should -Not -BeLike '*--model*'
        Start-ClaudeDrone -Skill widget-spin -DryRun -Model gadget | Should -BeLike "*--agent 'drone-sonnet' --model 'gadget'*"
    }

    It 'passes the brief, the skill line first, as the last argument, keeping its quotes' {
        Start-ClaudeDrone -Skill widget-spin -DryRun -Prompt "do the widget's work" |
            Should -BeLike "*--agent 'drone-sonnet' 'skill: widget-spin. do the widget''s work'*"
    }

    It 'starts as many drones as -Count asks for, each titled by its index' {
        $result = @(Start-ClaudeDrone -Skill widget-spin -Count 3 -PassThru)
        $result.Count | Should -Be 3
        $result[2] | Should -BeLike '*--title claude-drone-3*'
        Should -Invoke Start-Process -ModuleName Catzc.Tooling.Claude -Times 3 -Exactly
    }

    It 'starts nothing and returns the command lines under -DryRun' {
        @(Start-ClaudeDrone -Skill widget-spin -Count 2 -DryRun).Count | Should -Be 2
        Should -Invoke Start-Process -ModuleName Catzc.Tooling.Claude -Times 0 -Exactly
    }

    It 'returns nothing without -PassThru' {
        Start-ClaudeDrone -Skill widget-spin | Should -BeNullOrEmpty
    }

    It 'takes the launcher from the config, and the caller wins over it' {
        $script:config = [Catzc.Tooling.Claude.ClaudeDroneConfig]::new([ordered]@{ launcher = 'pwsh' })
        Start-ClaudeDrone -Skill widget-spin -DryRun |
            Should -BeExactly "pwsh -NoExit -Command `"& claude --agent 'drone-sonnet' 'skill: widget-spin'`""
        Start-ClaudeDrone -Skill widget-spin -DryRun -Launcher windows-terminal | Should -BeLike 'wt.exe *'
    }

    It 'escapes a semicolon for the windows terminal, which reads it as a command separator' {
        Start-ClaudeDrone -Skill widget-spin -DryRun -Prompt 'one; two' | Should -BeLike "*'skill: widget-spin. one\; two'*"
    }

    It 'rejects a count outside 1 to 20' {
        { Start-ClaudeDrone -Skill widget-spin -Count 0 -DryRun } | Should -Throw
        { Start-ClaudeDrone -Skill widget-spin -Count 21 -DryRun } | Should -Throw
    }
}
