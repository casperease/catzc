# cspell:ignore tmain tforeground tbackground tsleep nsleep tsubagent tpipeline  -- "`t"/"`n" escape artifacts in the tab-separated log lines
Describe 'BashSafeguard' -Tag 'L0', 'logic' {
    BeforeAll {
        # Tight fixture limits, so every verdict is visible: devbox 7 s / 70 s, pipeline 60 s / 600 s.
        $script:config = [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{
                limits = @{
                    devbox   = @{ bash = @{ foreground = 7; background = 70 } }
                    pipeline = @{ bash = @{ foreground = 60; background = 600 } }
                }
            })

        function script:Get-Verdict {
            param(
                [hashtable] $ToolInput,
                [string] $Environment = 'Devbox',
                [string] $AgentId,
                [string] $AgentType
            )
            $payload = @{ tool_name = 'Bash'; tool_input = $ToolInput }
            if ($AgentId) {
                $payload.agent_id = $AgentId
            }
            if ($AgentType) {
                $payload.agent_type = $AgentType
            }
            $logLine = $null
            $reason = [Catzc.Base.Timeouts.BashSafeguard]::Decide(($payload | ConvertTo-Json -Compress), $script:config, $Environment, [ref] $logLine)
            [pscustomobject]@{ Reason = $reason; LogLine = $logLine }
        }
    }

    Context 'run environment' {
        It 'is <expected> for TF_BUILD=<tf> GITHUB_ACTIONS=<gh>' -ForEach @(
            @{ tf = $null; gh = $null; expected = 'Devbox' }
            @{ tf = ''; gh = ''; expected = 'Devbox' }
            @{ tf = 'True'; gh = $null; expected = 'Pipeline' }
            @{ tf = $null; gh = 'true'; expected = 'Pipeline' }
        ) {
            [Catzc.Base.Timeouts.BashSafeguard]::EnvironmentOf($tf, $gh) | Should -Be $expected
        }

        It 'agrees with Test-IsRunningInPipeline on this session' {
            $environment = [Catzc.Base.Timeouts.BashSafeguard]::EnvironmentOf($env:TF_BUILD, $env:GITHUB_ACTIONS)
            ($environment -eq 'Pipeline') | Should -Be (Test-IsRunningInPipeline)
        }
    }

    Context 'foreground calls' {
        It 'allows a timeout within the <environment> limit' -ForEach @(
            @{ environment = 'Devbox'; timeout = 7000 }
            @{ environment = 'Pipeline'; timeout = 60000 }
        ) {
            $verdict = Get-Verdict @{ command = 'ls'; timeout = $timeout } -Environment $environment
            $verdict.Reason | Should -BeNullOrEmpty
            $verdict.LogLine | Should -BeNullOrEmpty
        }

        It 'denies <case>, naming the limit' -ForEach @(
            @{ case = 'a missing timeout'; toolInput = @{ command = 'ls' }; asked = 'no timeout' }
            @{ case = 'a timeout over the limit'; toolInput = @{ command = 'ls'; timeout = 7001 }; asked = 'timeout 7001 ms' }
            @{ case = 'a zero timeout'; toolInput = @{ command = 'ls'; timeout = 0 }; asked = 'timeout 0 ms' }
        ) {
            $verdict = Get-Verdict $toolInput
            $verdict.Reason | Should -BeLike "*(Devbox, foreground)*has $asked;*timeout <= 7000 ms*"
            $verdict.LogLine | Should -BeLike "*`tDevbox`tmain`tforeground`t$asked`t7 s`tls"
        }

        It 'uses the pipeline limit in a pipeline' {
            (Get-Verdict @{ command = 'ls'; timeout = 60001 } -Environment Pipeline).Reason | Should -BeLike '*timeout <= 60000 ms*'
        }
    }

    Context 'background calls' {
        It 'allows a single command behind a timeout prefix within the limit: <command>' -ForEach @(
            @{ command = 'timeout 70 pwsh -NoProfile -File out/widget.ps1' }
            @{ command = 'timeout -k 5 1m pwsh -NoProfile -Command ". ./importer.ps1; Invoke-Widget"' }
            @{ command = 'timeout --kill-after=5 --preserve-status 60s bash out/widget.sh 2>&1' }
            @{ command = "timeout 70 grep -n 'a;b|c' widget.txt &> out/widget.log" }
            @{ command = 'timeout 70 echo "$(date; hostname)" `uname | tr a b`' }
        ) {
            (Get-Verdict @{ command = $command; run_in_background = $true }).Reason | Should -BeNullOrEmpty
        }

        It 'ignores the tool timeout parameter, which the Bash tool does not apply in the background' {
            $verdict = Get-Verdict @{ command = 'sleep 30'; timeout = 5000; run_in_background = $true }
            $verdict.Reason | Should -BeLike '*has no*timeout <duration>*prefix*'
            $verdict.LogLine | Should -BeLike "*`tbackground`tno timeout prefix`t70 s`tsleep 30"
        }

        It 'denies a duration over the background limit or zero: <command>' -ForEach @(
            @{ command = 'timeout 71 sleep 1'; asked = 'timeout 71 s' }
            @{ command = 'timeout 2m sleep 1'; asked = 'timeout 120 s' }
            @{ command = 'timeout 0 sleep 1'; asked = 'timeout 0 s' }
        ) {
            (Get-Verdict @{ command = $command; run_in_background = $true }).Reason | Should -BeLike "*has $asked; the background limit is 70 s*"
        }

        It 'denies a compound command, which would leave its later commands unbounded: <command>' -ForEach @(
            @{ command = 'timeout 70 make && sleep 999' }
            @{ command = 'timeout 70 make || sleep 999' }
            @{ command = 'timeout 70 make; sleep 999' }
            @{ command = 'timeout 70 make | tee out/widget.log' }
            @{ command = 'timeout 70 make & sleep 999' }
            @{ command = "timeout 70 make`nsleep 999" }
        ) {
            (Get-Verdict @{ command = $command; run_in_background = $true }).Reason | Should -BeLike '*compound command*'
        }

        It 'denies a prefix that is not a GNU timeout: <command>' -ForEach @(
            @{ command = 'sleep 30' }
            @{ command = 'timeout' }
            @{ command = 'timeout 70' }
            @{ command = 'timeout ten sleep 1' }
            @{ command = 'timeouts 70 sleep 1' }
        ) {
            (Get-Verdict @{ command = $command; run_in_background = $true }).Reason | Should -BeLike '*has no*timeout <duration>*prefix*'
        }

        It 'uses the pipeline background limit in a pipeline' {
            (Get-Verdict @{ command = 'timeout 600 sleep 1'; run_in_background = $true } -Environment Pipeline).Reason | Should -BeNullOrEmpty
            (Get-Verdict @{ command = 'timeout 601 sleep 1'; run_in_background = $true } -Environment Pipeline).Reason |
                Should -BeLike '*background limit is 600 s*'
        }
    }

    Context 'who is asked to act on a denial' {
        It 'asks the main session to raise the blocker with the user' {
            $verdict = Get-Verdict @{ command = 'ls' }
            $verdict.Reason | Should -BeLike '*raise it with the user as a blocker*'
            $verdict.LogLine | Should -BeLike "*`tmain`t*"
        }

        It 'asks a subagent to report to its coordinator, logging its type' {
            $verdict = Get-Verdict @{ command = 'ls' } -AgentId 'a1b2' -AgentType 'catzc-worker'
            $verdict.Reason | Should -BeLike '*You are a subagent: report the blocker to your coordinator*'
            $verdict.LogLine | Should -BeLike "*`tsubagent:catzc-worker`t*"
        }

        It 'falls back to the agent id when the type is absent' {
            (Get-Verdict @{ command = 'ls' } -AgentId 'a1b2').LogLine | Should -BeLike "*`tsubagent:a1b2`t*"
        }

        It 'tells a pipeline to fix the call or its limit, even for an agent' {
            $verdict = Get-Verdict @{ command = 'ls' } -Environment Pipeline -AgentId 'a1b2'
            $verdict.Reason | Should -BeLike '*In a pipeline nobody tunes it live*'
            $verdict.LogLine | Should -BeLike "*`tPipeline`tpipeline`t*"
        }
    }

    Context 'hook output' {
        It 'renders a PreToolUse denial' {
            $decision = ([Catzc.Base.Timeouts.BashSafeguard]::DenyOutput('widget reason') | ConvertFrom-Json).hookSpecificOutput
            $decision.hookEventName | Should -Be 'PreToolUse'
            $decision.permissionDecision | Should -Be 'deny'
            $decision.permissionDecisionReason | Should -Be 'widget reason'
        }

        It 'truncates the logged command to 120 characters on one line' {
            $verdict = Get-Verdict @{ command = "echo $('x' * 200)`nls" }
            ($verdict.LogLine -split "`t")[-1].Length | Should -Be 120
            $verdict.LogLine | Should -Not -Match "`n"
        }

        It 'throws on a payload that is not JSON' {
            $logLine = $null
            { [Catzc.Base.Timeouts.BashSafeguard]::Decide('not json', $script:config, 'Devbox', [ref] $logLine) } | Should -Throw
        }
    }
}
