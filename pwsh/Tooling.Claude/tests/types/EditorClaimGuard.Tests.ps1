Describe 'Catzc.Tooling.Claude.EditorClaimGuard' -Tag 'L0', 'logic' {
    BeforeAll {
        # A hook payload as Claude Code sends it, for one tool on one file.
        function New-Payload {
            param([string] $Tool = 'Edit', [string] $Session, [string] $File, [string] $Cwd)
            $payload = [ordered]@{ hook_event_name = 'PreToolUse'; tool_name = $Tool; session_id = $Session; tool_input = @{ file_path = $File } }
            if ($Cwd) {
                $payload['cwd'] = $Cwd
            }
            $payload | ConvertTo-Json -Compress
        }
    }

    BeforeEach {
        $script:folder = Join-Path $TestDrive "claims-$([guid]::NewGuid().ToString('n'))"
        $script:file = Join-Path $TestDrive 'widget/configs/widget.yml'
        $script:now = [datetime]::new(2026, 1, 2, 3, 4, 5, [System.DateTimeKind]::Utc)
        $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $now.AddSeconds(120), $now)
    }

    It 'denies a second session''s <Tool> of a claimed file, naming the claimant and the expiry' -ForEach @(
        @{ Tool = 'Edit' }
        @{ Tool = 'Write' }
        @{ Tool = 'MultiEdit' }
    ) {
        $reason = [Catzc.Tooling.Claude.EditorClaimGuard]::Decide((New-Payload -Tool $Tool -Session 'gadget-session' -File $file), $folder, $now)
        $reason | Should -BeLike '*claimed by session widget-session until 03:06:05 UTC*Unlock-SharedConfig*'
    }

    It 'allows the claimant''s own Edit of the claimed file' {
        [Catzc.Tooling.Claude.EditorClaimGuard]::Decide((New-Payload -Session 'widget-session' -File $file), $folder, $now) | Should -BeNullOrEmpty
    }

    It 'resolves a relative file against the payload''s working folder' {
        $payload = New-Payload -Session 'gadget-session' -File 'configs/widget.yml' -Cwd (Join-Path $TestDrive 'widget')
        [Catzc.Tooling.Claude.EditorClaimGuard]::Decide($payload, $folder, $now) | Should -Not -BeNullOrEmpty
    }

    It 'allows <Case>' -ForEach @(
        @{ Case = 'an Edit of a file no one claimed'; Tool = 'Edit'; File = 'gadget.yml'; At = 0 }
        @{ Case = 'a second session''s Edit once the claim expired'; Tool = 'Edit'; File = 'widget/configs/widget.yml'; At = 120 }
        @{ Case = 'a tool that edits no file'; Tool = 'Read'; File = 'widget/configs/widget.yml'; At = 0 }
    ) {
        $payload = New-Payload -Tool $Tool -Session 'gadget-session' -File (Join-Path $TestDrive $File)
        [Catzc.Tooling.Claude.EditorClaimGuard]::Decide($payload, $folder, $now.AddSeconds($At)) | Should -BeNullOrEmpty
    }

    It 'allows a relative file when the payload names no working folder' {
        [Catzc.Tooling.Claude.EditorClaimGuard]::Decide((New-Payload -Session 'gadget-session' -File 'widget.yml'), $folder, $now) |
            Should -BeNullOrEmpty
    }

    It 'writes the PreToolUse deny output with the reason' {
        $decision = ([Catzc.Tooling.Claude.EditorClaimGuard]::DenyOutput('widget reason') | ConvertFrom-Json).hookSpecificOutput
        $decision.hookEventName | Should -BeExactly 'PreToolUse'
        $decision.permissionDecision | Should -BeExactly 'deny'
        $decision.permissionDecisionReason | Should -BeExactly 'widget reason'
    }
}
