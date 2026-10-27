Describe 'Unlock-SharedConfig' -Tag 'L0', 'logic' {
    BeforeEach {
        # The claim folder sits under the temporary folder, so each test gets its own.
        $script:savedTemp = $env:TMP, $env:TEMP, $env:TMPDIR
        $env:TMP = $env:TEMP = $env:TMPDIR = Join-Path $TestDrive "temp-$([guid]::NewGuid().ToString('n'))"
        $script:file = Join-Path $TestDrive 'widget.yml'
        Set-Content -LiteralPath $script:file -Value 'widget: 1'
        Mock Get-Config -ModuleName Catzc.Tooling.Claude -ParameterFilter { $Config -eq 'editor-claims' } {
            [Catzc.Tooling.Claude.EditorClaimsConfig]::new([ordered]@{ shared_configs = @('widget') })
        }
        Mock Get-Config -ModuleName Catzc.Tooling.Claude -ParameterFilter { $ListOwners } { @{ Name = 'widget'; Path = $script:file } }
        Mock Write-Message -ModuleName Catzc.Tooling.Claude { }
        $script:now = [datetime]::UtcNow
        $script:folder = [Catzc.Tooling.Claude.EditorClaim]::DefaultFolder()
    }

    AfterEach {
        $env:TMP, $env:TEMP, $env:TMPDIR = $script:savedTemp
    }

    It 'releases the session''s claim, so another session may claim it, and announces it' {
        $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $now.AddSeconds(120), $now)
        Unlock-SharedConfig widget -Session 'widget-session' | Should -BeNullOrEmpty
        [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file, [datetime]::UtcNow) | Should -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Claude -Times 1 -Exactly -ParameterFilter { $Message -eq "Editor claim: 'widget' is free to claim" }
    }

    It 'releases nothing, without an error, when no session holds a claim' {
        { Unlock-SharedConfig widget -Session 'widget-session' } | Should -Not -Throw
    }

    It 'takes the session from CLAUDE_CODE_SESSION_ID by default' {
        $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'gadget-session', $now.AddSeconds(120), $now)
        $saved = $env:CLAUDE_CODE_SESSION_ID
        $env:CLAUDE_CODE_SESSION_ID = 'gadget-session'
        try {
            Unlock-SharedConfig widget
        }
        finally {
            $env:CLAUDE_CODE_SESSION_ID = $saved
        }
        [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file, [datetime]::UtcNow) | Should -BeNullOrEmpty
    }

    It 'throws, naming the claimant, and keeps another session''s claim' {
        $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $now.AddSeconds(120), $now)
        { Unlock-SharedConfig widget -Session 'gadget-session' } | Should -Throw "*'widget' is claimed by session widget-session*no claim to release*"
        [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file, [datetime]::UtcNow).Session | Should -BeExactly 'widget-session'
    }

    It 'throws for a config that is not shared' {
        { Unlock-SharedConfig gadget -Session 'widget-session' } | Should -Throw "*'gadget' is not a shared config*"
    }

    It 'throws without a session id' {
        { Unlock-SharedConfig widget -Session '' } | Should -Throw '*no session id*'
    }
}
