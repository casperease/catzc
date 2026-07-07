# Binds the SHIPPED configs (key-handler-bindings.yml + key-handler-supported.yml) through Get-Config and the
# real convention validators — an integrity check on what the module ships, asserting structural invariants
# only (never a specific captured key→function pair, which a re-capture may legitimately change: ADR-TEST:17).
Describe 'Import-PSReadLineKeyHandlerSet (shipped configs)' -Tag 'L1', 'integrity' {

    BeforeAll {
        $script:plan = Import-PSReadLineKeyHandlerSet -DryRun
        $script:supported = @((Get-Config -Config key-handler-supported)['functions'])
    }

    It 'shipped configs load and validate, producing a non-empty plan' {
        @($script:plan).Count | Should -BeGreaterThan 0
    }

    It 'every planned binding carries a non-empty key and function' {
        $malformed = @($script:plan | Where-Object { [string]::IsNullOrWhiteSpace($_.Key) -or [string]::IsNullOrWhiteSpace($_.Function) })
        $malformed.Count | Should -Be 0
    }

    It 'a binding is marked supported exactly when its function is in the shipped allow-list' {
        $supportedSet = [System.Collections.Generic.HashSet[string]]::new([string[]] $script:supported, [System.StringComparer]::OrdinalIgnoreCase)
        $mismatch = @($script:plan | Where-Object { $_.Supported -ne $supportedSet.Contains($_.Function) })
        $mismatch.Count | Should -Be 0
    }

    It 'the DryRun plan applies nothing to the session' {
        Mock Set-PSReadLineKeyHandler { } -ModuleName Catzc.Tooling.KeyHandler
        Import-PSReadLineKeyHandlerSet -DryRun | Out-Null
        Should -Invoke Set-PSReadLineKeyHandler -ModuleName Catzc.Tooling.KeyHandler -Times 0
    }
}
