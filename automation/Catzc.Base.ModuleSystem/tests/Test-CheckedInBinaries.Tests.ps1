Describe 'Checked-in binaries are stored as binary, not text' -Tag 'L2', 'integrity' {
    BeforeAll {
        $script:repoRoot = Get-RepositoryRoot
        $script:skip = $null

        # L2: drives the real git CLI. Self-skip when git is absent or we are not inside a work tree
        # (e.g. running from an exported tarball), per the test-automation tiering ADR.
        if (-not (Get-Command git -ErrorAction Ignore)) {
            $script:skip = 'tool_git_missing'
        }
        else {
            $inside = try {
                & git -C $repoRoot rev-parse --is-inside-work-tree 2>$null
            }
            catch {
                $null
            }
            if ($inside -ne 'true') {
                $script:skip = 'repo_no_worktree'
            }
        }

        # The two locations that hold checked-in binaries:
        #   automation/.vendor/**     — vendored modules' .dll/.pdb/...
        #   automation/.compiled/**   — the committed combined C# types assembly (see caching ADR)
        # A file is "binary" the way git itself decides — a NUL byte in the first 8000 bytes — so the test
        # tracks reality rather than an extension allow-list. For each binary we read git's index EOL:
        # `git ls-files --eol` => "i/<index> w/<worktree> attr/<attr><TAB><path>". A binary stored as text
        # would show i/lf | i/crlf | i/mixed (git applied EOL conversion and corrupted the bytes); a
        # correctly-stored binary is i/-text (no conversion, byte-exact).
        $script:binaries = @()
        if (-not $script:skip) {
            foreach ($line in (& git -C $repoRoot ls-files --eol -- automation)) {
                if ($line -notmatch '^i/(?<idx>\S+)\s+w/\S*\s+attr/\S*\s+(?<path>.+)$') {
                    continue
                }
                $idx = $Matches['idx']
                $path = $Matches['path'].Trim()                     # NOTE: any later -match overwrites $Matches
                if ($path -notmatch '^automation/\.vendor/' -and $path -notmatch '^automation/\.compiled/') {
                    continue
                }

                $full = Join-Path $repoRoot $path
                if (-not (Test-Path -LiteralPath $full)) {
                    continue
                }

                $stream = [System.IO.File]::OpenRead($full)
                try {
                    $buf = [byte[]]::new(8000)
                    $read = $stream.Read($buf, 0, $buf.Length)
                }
                finally {
                    $stream.Dispose()
                }

                $isBinary = $false
                for ($i = 0; $i -lt $read; $i++) {
                    if ($buf[$i] -eq 0) {
                        $isBinary = $true; break
                    }
                }
                if (-not $isBinary) {
                    continue
                }

                $script:binaries += [pscustomobject]@{ Path = $path; IndexEol = $idx }
            }
        }
    }

    It 'finds checked-in binary files to verify (guards against a vacuous pass)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        @($script:binaries).Count | Should -BeGreaterThan 0
    }

    It 'stores every binary with no EOL conversion (git index is i/-text)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }

        $textified = @($script:binaries | Where-Object { $_.IndexEol -in @('lf', 'crlf', 'mixed') })
        $detail = ($textified | ForEach-Object { "$($_.Path) (git index eol = $($_.IndexEol))" }) -join '; '
        $textified | Should -HaveCount 0 -Because "these binaries are stored as text, not binary: $detail"
    }

    It 'carries an explicit binary attribute (a .gitattributes rule, not just auto-detection)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }

        # `git check-attr binary` reports the `binary` macro as `set` ONLY when an attributes rule applies —
        # it never content-sniffs — so `set` proves an explicit .gitattributes rule rather than git's
        # auto-detection. It resolves from the committed/staged .gitattributes, so this guards CI too: it
        # fails if a rule is removed, before any actual byte corruption could occur. Each output line is
        # "<path>: binary: set" (or "binary: unspecified" when no rule matches).
        $paths = @($script:binaries.Path)
        $lines = & git -C $repoRoot check-attr binary -- $paths
        $unmarked = @($lines | Where-Object { $_ -notmatch ':\s*binary:\s*set$' })
        $unmarked | Should -HaveCount 0 -Because "these paths lack an explicit binary .gitattributes rule: $($unmarked -join '; ')"
    }
}
