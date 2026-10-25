Describe 'Catzc.Base.VSCode.VscodeSession' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-Session {
            param($LoadedHash = 'aaaa1111', $SourceHash = 'aaaa1111', [bool] $Current = $true, $Drift = $null, $Held = $null)
            [Catzc.Base.VSCode.VscodeSession]::new('ConsoleHost', 1234, $LoadedHash, $SourceHash, $Current, $Drift, $null, $Held, $null, $null, $null)
        }
    }

    It 'keeps the values it is given' {
        $session = [Catzc.Base.VSCode.VscodeSession]::new('widget host', 42, 'aaaa1111', 'bbbb2222', $false, [string[]] @('Gadget'), [string[]] @('Catzc.Types.aaaa1111.dll'), [string[]] @('Catzc.Types.aaaa1111.dll held by 7'), [string[]] @('WIDGET_VAR'), 'log-folder', [string[]] @('started'))
        $session.HostName | Should -BeExactly 'widget host'
        $session.ProcessId | Should -Be 42
        @($session.LoadedHash, $session.SourceHash) | Should -Be @('aaaa1111', 'bbbb2222')
        $session.Current | Should -BeFalse
        $session.Drift | Should -Be @('Gadget')
        $session.Builds | Should -Be @('Catzc.Types.aaaa1111.dll')
        $session.HeldBuilds | Should -Be @('Catzc.Types.aaaa1111.dll held by 7')
        $session.ContributedVariables | Should -Be @('WIDGET_VAR')
        $session.LogSession | Should -BeExactly 'log-folder'
        $session.PowerShellLogLines | Should -Be @('started')
    }

    It 'reads a missing list as an empty one, never null' {
        $session = New-Session
        foreach ($list in $session.Drift, $session.Builds, $session.HeldBuilds, $session.ContributedVariables, $session.PowerShellLogLines) {
            , $list | Should -BeOfType ([string[]])
            $list.Count | Should -Be 0
        }
        $session.LogSession | Should -BeNullOrEmpty
    }

    It 'describes a current session in one line' {
        (New-Session).ToString() | Should -BeExactly 'pwsh 1234 in ConsoleHost: types aaaa1111 of sources aaaa1111 (current); 0 held build(s)'
    }

    It 'says what is not known: no loaded instance, no source hash, a session bound to an earlier instance' {
        # A PowerShell $null becomes an empty string at a string parameter, so a real null is the NullString value.
        (New-Session -LoadedHash ([NullString]::Value) -SourceHash ([NullString]::Value)).ToString() | Should -BeExactly 'pwsh 1234 in ConsoleHost: types not loaded of sources unknown (current); 0 held build(s)'
        (New-Session -SourceHash 'bbbb2222' -Current $false -Held ([string[]] @('one', 'two'))).ToString() |
            Should -BeExactly 'pwsh 1234 in ConsoleHost: types aaaa1111 of sources bbbb2222 (bound to an earlier instance); 2 held build(s)'
    }
}
