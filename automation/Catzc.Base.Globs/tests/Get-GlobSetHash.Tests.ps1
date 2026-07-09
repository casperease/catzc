# cspell:ignore ntwo  -- the escape-sequence artifact in the "one`ntwo" CRLF/LF fixture strings
# The durable SHA (ADR-FLOW-CD-GLOBS:5): 64-hex-lowercase, EOL-insensitive, path-folded, ordinal, with the
# <path>|missing marker for an unstaged deletion.
Describe 'Get-GlobSetHash' -Tag 'L1', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot
        $script:data = Join-Path $script:fake.Root 'data'
        New-Item -ItemType Directory -Path $script:data -Force | Out-Null

        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = @{ unit = @{ description = 'd'; layer = 'loose-fileset'; include = @('data/**') } }
            })
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    BeforeEach {
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
    }

    It 'returns 64 lowercase hex chars and is deterministic' {
        Set-Content (Join-Path $script:data 'a.txt') 'alpha' -NoNewline
        Mock Get-TrackedFile { @('data/a.txt') } -ModuleName Catzc.Base.Globs

        $first = Get-GlobSetHash -Name unit
        $second = Get-GlobSetHash -Name unit
        $first | Should -MatchExactly '^[0-9a-f]{64}$'
        $second | Should -Be $first
    }

    It 'is EOL-insensitive: CRLF and LF bodies key the same' {
        [System.IO.File]::WriteAllText((Join-Path $script:data 'e.txt'), "one`r`ntwo`r`n")
        Mock Get-TrackedFile { @('data/e.txt') } -ModuleName Catzc.Base.Globs
        $crlf = Get-GlobSetHash -Name unit

        [System.IO.File]::WriteAllText((Join-Path $script:data 'e.txt'), "one`ntwo`n")
        $lf = Get-GlobSetHash -Name unit

        $lf | Should -Be $crlf
    }

    It 're-keys on a content change' {
        Set-Content (Join-Path $script:data 'c.txt') 'v1' -NoNewline
        Mock Get-TrackedFile { @('data/c.txt') } -ModuleName Catzc.Base.Globs
        $before = Get-GlobSetHash -Name unit

        Set-Content (Join-Path $script:data 'c.txt') 'v2' -NoNewline
        Get-GlobSetHash -Name unit | Should -Not -Be $before
    }

    It 're-keys on a rename even with identical content (the path is folded)' {
        Set-Content (Join-Path $script:data 'n1.txt') 'same' -NoNewline
        Set-Content (Join-Path $script:data 'n2.txt') 'same' -NoNewline
        Mock Get-TrackedFile { @('data/n1.txt') } -ModuleName Catzc.Base.Globs
        $asN1 = Get-GlobSetHash -Name unit

        Mock Get-TrackedFile { @('data/n2.txt') } -ModuleName Catzc.Base.Globs
        Get-GlobSetHash -Name unit | Should -Not -Be $asN1
    }

    It 'folds a distinct marker for a tracked-but-missing member instead of throwing' {
        Set-Content (Join-Path $script:data 'gone.txt') 'here' -NoNewline
        Mock Get-TrackedFile { @('data/gone.txt') } -ModuleName Catzc.Base.Globs
        $present = Get-GlobSetHash -Name unit

        Remove-Item (Join-Path $script:data 'gone.txt')
        $missing = Get-GlobSetHash -Name unit

        $missing | Should -MatchExactly '^[0-9a-f]{64}$'
        $missing | Should -Not -Be $present
    }

    It 'hashes an empty membership deterministically' {
        Mock Get-TrackedFile { @() } -ModuleName Catzc.Base.Globs
        $empty = Get-GlobSetHash -Name unit
        $empty | Should -MatchExactly '^[0-9a-f]{64}$'
        Get-GlobSetHash -Name unit | Should -Be $empty
    }

    Context '-GlobSet (a derived set, not in the declared registry)' {
        It 'hashes a GlobSet object to the same identity as an equivalent declared set' {
            Set-Content (Join-Path $script:data 'o.txt') 'object-path' -NoNewline
            Mock Get-TrackedFile { @('data/o.txt') } -ModuleName Catzc.Base.Globs

            $derived = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'module', @('data/**'), @(), @(), @(), -1, $null)
            Get-GlobSetHash -GlobSet $derived | Should -Be (Get-GlobSetHash -Name unit)
        }

        It 'scopes membership to the object, not the registry' {
            Set-Content (Join-Path $script:data 'in.txt') 'inside' -NoNewline
            Mock Get-TrackedFile { @('data/in.txt', 'other/out.txt') } -ModuleName Catzc.Base.Globs

            $narrow = [Catzc.Base.Globs.GlobSet]::new('narrow', 'd', 'module', @('data/**'), @(), @(), @(), -1, $null)
            $wide = [Catzc.Base.Globs.GlobSet]::new('wide', 'd', 'module', @('data/**', 'other/**'), @(), @(), @(), -1, $null)
            Get-GlobSetHash -GlobSet $narrow | Should -Not -Be (Get-GlobSetHash -GlobSet $wide)
        }
    }
}
