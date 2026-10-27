Describe 'Catzc.Tooling.Claude.EditorClaim' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:folder = Join-Path $TestDrive "claims-$([guid]::NewGuid().ToString('n'))"
        $script:file = Join-Path $TestDrive 'widget/configs/widget.yml'
        $script:now = [datetime]::new(2026, 1, 2, 3, 4, 5, [System.DateTimeKind]::Utc)
        $script:later = $script:now.AddSeconds(120)
    }

    Context 'claim' {
        It 'claims a free path for the session until the expiry, and reads it back' {
            $claim = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $later, $now)
            $claim.Session | Should -BeExactly 'widget-session'
            $claim.Expires | Should -Be $later
            $read = [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file, $now)
            $read.Session | Should -BeExactly 'widget-session'
            $read.Path | Should -BeExactly ([Catzc.Tooling.Claude.EditorClaim]::NormalPath($file))
        }

        It 'returns the live claim of another session and leaves it alone' {
            $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $later, $now)
            $held = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'gadget-session', $later.AddSeconds(60), $now)
            $held.Session | Should -BeExactly 'widget-session'
            $held.Expires | Should -Be $later
        }

        It 'renews the claimant''s own claim' {
            $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $later, $now)
            $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $later.AddSeconds(60), $now)
            [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file, $now).Expires | Should -Be $later.AddSeconds(60)
        }

        It 'keys a path by one spelling, whatever its separators' {
            $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $later, $now)
            [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file.Replace('\', '/'), $now).Session | Should -BeExactly 'widget-session'
            [Catzc.Tooling.Claude.EditorClaim]::Read($folder, (Join-Path $TestDrive 'widget/configs/gadget.yml'), $now) | Should -BeNullOrEmpty
        }

        It 'refuses a session id that would break the record: <Case>' -ForEach @(
            @{ Case = 'empty'; Session = '' }
            @{ Case = 'a field separator'; Session = 'widget|gadget' }
            @{ Case = 'a line break'; Session = "widget`ngadget" }
        ) {
            { [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, $Session, $later, $now) } | Should -Throw '*session id*'
        }
    }

    Context 'expiry' {
        It 'counts a claim past its expiry as none, so another session takes the path' {
            $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $later, $now)
            [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file, $later) | Should -BeNullOrEmpty
            $taken = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'gadget-session', $later.AddSeconds(120), $later)
            $taken.Session | Should -BeExactly 'gadget-session'
        }

        It 'counts a record that is <Case> as none' -ForEach @(
            @{ Case = 'empty'; Text = '' }
            @{ Case = 'cut short'; Text = 'widget-session|12' }
            @{ Case = 'a bad expiry'; Text = 'widget-session|soon|{path}' }
            @{ Case = 'another path'; Text = 'widget-session|{ticks}|c:/gadget.yml' }
        ) {
            $record = [Catzc.Tooling.Claude.EditorClaim]::RecordPath($folder, $file)
            $null = New-Item -ItemType Directory -Force -Path $folder
            $line = $Text.Replace('{path}', [Catzc.Tooling.Claude.EditorClaim]::NormalPath($file)).Replace('{ticks}', $later.Ticks)
            Set-Content -LiteralPath $record -Value $line -NoNewline
            [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file, $now) | Should -BeNullOrEmpty
        }
    }

    Context 'release' {
        It 'releases the claimant''s claim, leaving the path free' {
            $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $later, $now)
            [Catzc.Tooling.Claude.EditorClaim]::Release($folder, $file, 'widget-session', $now) | Should -BeNullOrEmpty
            [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file, $now) | Should -BeNullOrEmpty
        }

        It 'returns another session''s live claim and keeps it' {
            $null = [Catzc.Tooling.Claude.EditorClaim]::Claim($folder, $file, 'widget-session', $later, $now)
            [Catzc.Tooling.Claude.EditorClaim]::Release($folder, $file, 'gadget-session', $now).Session | Should -BeExactly 'widget-session'
            [Catzc.Tooling.Claude.EditorClaim]::Read($folder, $file, $now).Session | Should -BeExactly 'widget-session'
        }

        It 'releases a path no one claims, in a folder that does not exist, as nothing to do' {
            [Catzc.Tooling.Claude.EditorClaim]::Release($folder, $file, 'widget-session', $now) | Should -BeNullOrEmpty
        }
    }
}
