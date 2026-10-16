<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/tests/types/BashSafeguard.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Timeouts
    relatives:
      page: docs/references/automation/catzc-base-timeouts/tests/types/BashSafeguard.Tests.ps1.md
      source: automation/Catzc.Base.Timeouts/types/BashSafeguard.cs
---
#>

# cspell:ignore tmain tforeground tbackground tsleep tsubagent tpipeline  -- "`t" escape artifacts in the tab-separated log lines
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
        BeforeDiscovery {
            $script:bashCases = @(Get-EngineCaseTable (Join-Path $PSScriptRoot '../assets/engine-cases/bounded-command.yml') -Engine bash -Applicable)
        }

        It 'words the <Fields.expect> verdict for: <Case>' -ForEach $bashCases {
            $reason = (Get-Verdict @{ command = $Fields.command; run_in_background = $true }).Reason
            switch ($Fields.expect) {
                'allow' {
                    $reason | Should -BeNullOrEmpty
                }
                'no-limit' {
                    $reason | Should -BeLike '*has no*timeout <duration>*prefix*'
                }
                'over-limit' {
                    $reason | Should -BeLike '*; the background limit is 70 s*'
                }
                'compound' {
                    $reason | Should -BeLike '*compound command*'
                }
                default {
                    throw "unknown expected verdict '$($Fields.expect)'"
                }
            }
        }

        It 'ignores the tool timeout parameter, which the Bash tool does not apply in the background' {
            $verdict = Get-Verdict @{ command = 'sleep 30'; timeout = 5000; run_in_background = $true }
            $verdict.Reason | Should -BeLike '*has no*timeout <duration>*prefix*'
            $verdict.LogLine | Should -BeLike "*`tbackground`tno timeout prefix`t70 s`tsleep 30"
        }

        It 'names the requested duration when it is over the background limit' {
            (Get-Verdict @{ command = 'timeout 2m sleep 1'; run_in_background = $true }).Reason |
                Should -BeLike '*has timeout 120 s; the background limit is 70 s*'
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
