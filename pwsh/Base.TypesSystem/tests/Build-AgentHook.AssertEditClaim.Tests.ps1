Describe 'Build-AgentHook — the published Assert-EditClaim' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:dotnetMissing = -not (Test-Command 'dotnet')
        if ($script:dotnetMissing) {
            return
        }
        # Publish the real program into the test drive; it reads its claims under the temporary folder each call is given.
        $script:program = Build-AgentHook Assert-EditClaim -OutputDirectory (Join-Path $TestDrive 'repo/.claude/hooks/bin') -Force
        $script:temp = Join-Path $TestDrive 'temp'
        $script:file = Join-Path $TestDrive 'repo/Base.Timeouts/configs/timeouts.yml'

        function Invoke-Hook {
            param([string] $Session, [string] $Tool = 'Edit')
            $payload = @{ hook_event_name = 'PreToolUse'; tool_name = $Tool; session_id = $Session; tool_input = @{ file_path = $script:file } } |
                ConvertTo-Json -Compress
            $saved = $env:TMP, $env:TEMP, $env:TMPDIR
            $env:TMP = $env:TEMP = $env:TMPDIR = $script:temp
            try {
                $output = $payload | & $script:program
            }
            finally {
                $env:TMP, $env:TEMP, $env:TMPDIR = $saved
            }
            [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = ($output -join '') }
        }
    }

    BeforeEach {
        if ($script:dotnetMissing) {
            return
        }
        Remove-Item -LiteralPath $script:temp -Recurse -Force -ErrorAction Ignore
        # The claim the widget session holds on timeouts.yml, written where the program finds it.
        $folder = Join-Path $script:temp 'catzc-run-queue/editor-claims'
        $now = [datetime]::UtcNow
        $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $script:file, 'widget-session', $now.AddSeconds(120), $now)
    }

    It 'denies a second session''s <Tool> of the claimed timeouts.yml' -ForEach @(
        @{ Tool = 'Edit' }
        @{ Tool = 'Write' }
    ) {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $result = Invoke-Hook -Session 'gadget-session' -Tool $Tool
        $result.ExitCode | Should -Be 0
        $decision = ($result.Output | ConvertFrom-Json).hookSpecificOutput
        $decision.hookEventName | Should -BeExactly 'PreToolUse'
        $decision.permissionDecision | Should -BeExactly 'deny'
        $decision.permissionDecisionReason | Should -BeLike '*timeouts.yml is claimed by session widget-session until*'
    }

    It 'allows the claimant''s Edit of the claimed timeouts.yml' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $result = Invoke-Hook -Session 'widget-session'
        $result.ExitCode | Should -Be 0
        $result.Output | Should -BeNullOrEmpty
    }

    It 'lets the call through, never blocking, on a payload it cannot read' {
        if ($script:dotnetMissing) {
            Set-ItResult -Skipped -Because 'tool_dotnet_missing'
            return
        }
        $output = 'not json' | & $script:program 2>$null
        $LASTEXITCODE | Should -Be 0
        ($output -join '') | Should -BeNullOrEmpty
    }
}
