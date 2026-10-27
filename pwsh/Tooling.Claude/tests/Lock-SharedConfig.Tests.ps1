Describe 'Lock-SharedConfig' -Tag 'L0', 'logic' {
    BeforeEach {
        # The claim folder sits under the temporary folder, so each test gets its own.
        $script:savedTemp = $env:TMP, $env:TEMP, $env:TMPDIR
        $env:TMP = $env:TEMP = $env:TMPDIR = Join-Path $TestDrive "temp-$([guid]::NewGuid().ToString('n'))"
        $script:file = Join-Path $TestDrive 'widget.yml'
        Set-Content -LiteralPath $script:file -Value 'widget: 1'
        Mock Get-Config -ModuleName Catzc.Tooling.Claude -ParameterFilter { $Config -eq 'editor-claims' } {
            [Catzc.Tooling.Claude.EditorClaimsConfig]::new([ordered]@{ shared_configs = @('widget') })
        }
        Mock Get-Config -ModuleName Catzc.Tooling.Claude -ParameterFilter { $Config -eq 'timeouts' } {
            [pscustomobject]@{ run_lock = @{ wait_seconds = 120 } }
        }
        Mock Get-Config -ModuleName Catzc.Tooling.Claude -ParameterFilter { $ListOwners } { @{ Name = 'widget'; Path = $script:file } }
        Mock Write-Message -ModuleName Catzc.Tooling.Claude { }
    }

    AfterEach {
        $env:TMP, $env:TEMP, $env:TMPDIR = $script:savedTemp
    }

    It 'claims the shared config''s file for the session for run_lock.wait_seconds, and announces it' {
        $before = [datetime]::UtcNow
        $claim = Lock-SharedConfig widget -Session 'widget-session'
        $claim | Should -BeOfType [Catzc.Tooling.Claude.EditorClaim]
        $claim.Session | Should -BeExactly 'widget-session'
        $claim.Path | Should -BeExactly ([Catzc.Tooling.Claude.EditorClaim]::NormalPath($file))
        $claim.Expires | Should -BeGreaterOrEqual $before.AddSeconds(120)
        $claim.Expires | Should -BeLessOrEqual ([datetime]::UtcNow.AddSeconds(120))
        Should -Invoke Write-Message -ModuleName Catzc.Tooling.Claude -Times 1 -Exactly -ParameterFilter { $Message -like "Editor claim: 'widget'*widget-session*" }
    }

    It 'renews the claimant''s own claim' {
        $null = Lock-SharedConfig widget -Session 'widget-session'
        (Lock-SharedConfig widget -Session 'widget-session').Session | Should -BeExactly 'widget-session'
    }

    It 'takes the session from CLAUDE_CODE_SESSION_ID by default' {
        $saved = $env:CLAUDE_CODE_SESSION_ID
        $env:CLAUDE_CODE_SESSION_ID = 'gadget-session'
        try {
            (Lock-SharedConfig widget).Session | Should -BeExactly 'gadget-session'
        }
        finally {
            $env:CLAUDE_CODE_SESSION_ID = $saved
        }
    }

    It 'throws, naming the claimant, while another session holds the claim' {
        $null = Lock-SharedConfig widget -Session 'widget-session'
        { Lock-SharedConfig widget -Session 'gadget-session' } | Should -Throw "*'widget' is claimed by session widget-session until*"
    }

    It 'throws for a config that is not shared' {
        { Lock-SharedConfig gadget -Session 'widget-session' } | Should -Throw "*'gadget' is not a shared config*shared_configs: widget*"
    }

    It 'throws when the config resolves to no single file' {
        Mock Get-Config -ModuleName Catzc.Tooling.Claude -ParameterFilter { $ListOwners } { @{ Name = 'widget'; Path = 'a' }, @{ Name = 'widget'; Path = 'b' } }
        { Lock-SharedConfig widget -Session 'widget-session' } | Should -Throw '*resolves to 2 files*'
    }

    It 'throws without a session id' {
        { Lock-SharedConfig widget -Session '' } | Should -Throw '*no session id*'
    }
}
