<#
---
catzc:
  immutable:
    with_body_sha: "37c31842701d"
  edges:
    code: pwsh/Catzc.Tooling.Claude/Start-ClaudeWorker.ps1
    cites:
      - ADR-PWSH-DRYRUN-EARLYRETURNBRANCH
---
#>

Describe 'Start-ClaudeWorker' -Tag 'L0', 'logic', 'ADR-PWSH-DRYRUN-EARLYRETURNBRANCH' {
    BeforeEach {
        $script:config = [Catzc.Tooling.Claude.ClaudeWorkerConfig]::new($null)
        Mock Get-Config -ModuleName Catzc.Tooling.Claude -ParameterFilter { $Config -eq 'claude-worker' } { $script:config }
        Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Claude { 'C:/widget/repo' }
        Mock Start-Process -ModuleName Catzc.Tooling.Claude { }
    }

    It 'starts one worker as the configured agent in the configured terminal, in the repository root' {
        $result = @(Start-ClaudeWorker -PassThru)
        $result.Count | Should -Be 1
        $result[0] | Should -BeOfType [string]
        $result[0] | Should -BeLike "wt.exe -d `"C:/widget/repo`" new-tab *pwsh -NoExit -Command `"& claude --agent 'catzc-worker'`""
        Should -Invoke Start-Process -ModuleName Catzc.Tooling.Claude -Times 1 -Exactly -ParameterFilter { $WorkingDirectory -eq 'C:/widget/repo' -and $FilePath -eq 'wt.exe' }
    }

    It 'adds --model only when a model is given' {
        Start-ClaudeWorker -DryRun | Should -Not -BeLike '*--model*'
        Start-ClaudeWorker -DryRun -Model gadget | Should -BeLike "*--agent 'catzc-worker' --model 'gadget'*"
    }

    It 'passes the prompt as the last argument, keeping its quotes' {
        Start-ClaudeWorker -DryRun -Prompt "do the widget's work" | Should -BeLike "*--agent 'catzc-worker' 'do the widget''s work'*"
    }

    It 'starts as many workers as -Count asks for, each titled by its index' {
        $result = @(Start-ClaudeWorker -Count 3 -PassThru)
        $result.Count | Should -Be 3
        $result[2] | Should -BeLike '*--title claude-worker-3*'
        Should -Invoke Start-Process -ModuleName Catzc.Tooling.Claude -Times 3 -Exactly
    }

    It 'starts nothing and returns the command lines under -DryRun' {
        @(Start-ClaudeWorker -Count 2 -DryRun).Count | Should -Be 2
        Should -Invoke Start-Process -ModuleName Catzc.Tooling.Claude -Times 0 -Exactly
    }

    It 'returns nothing without -PassThru' {
        Start-ClaudeWorker | Should -BeNullOrEmpty
    }

    It 'takes the agent and launcher from the config, and the caller wins over it' {
        $script:config = [Catzc.Tooling.Claude.ClaudeWorkerConfig]::new([ordered]@{ agent = 'gadget-agent'; launcher = 'pwsh' })
        Start-ClaudeWorker -DryRun | Should -BeExactly "pwsh -NoExit -Command `"& claude --agent 'gadget-agent'`""
        $called = Start-ClaudeWorker -DryRun -Agent widget-agent -Launcher windows-terminal
        $called | Should -BeLike 'wt.exe *'
        $called | Should -BeLike "*--agent 'widget-agent'*"
    }

    It 'escapes a semicolon for the windows terminal, which reads it as a command separator' {
        Start-ClaudeWorker -DryRun -Prompt 'one; two' | Should -BeLike "*'one\; two'*"
    }

    It 'rejects a count outside 1 to 20' {
        { Start-ClaudeWorker -Count 0 -DryRun } | Should -Throw
        { Start-ClaudeWorker -Count 21 -DryRun } | Should -Throw
    }
}
