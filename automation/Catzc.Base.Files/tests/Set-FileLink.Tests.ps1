Describe 'Set-FileLink' -Tag 'L1', 'logic' {
    BeforeAll {
        # Capability probe: symbolic links need a privilege on Windows (Developer Mode / admin); hard links do
        # not. The assertions branch on the probe — deterministic per machine, never a retry (ADR-RETRY:1).
        $probeSource = Join-Path $TestDrive 'probe-source.txt'
        Set-Content -Path $probeSource -Value 'probe'
        $script:canCreateSymbolicLink = $true
        try {
            New-Item -ItemType SymbolicLink -Path (Join-Path $TestDrive 'probe-link.txt') -Target $probeSource -ErrorAction Stop | Out-Null
        }
        catch {
            $script:canCreateSymbolicLink = $false
        }
    }

    BeforeEach {
        $script:sourcePath = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '-source.txt')
        $script:linkPath = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '-link.txt')
        [System.IO.File]::WriteAllText($script:sourcePath, "alpha`n")
    }

    It 'creates a link where nothing exists and reports changed' {
        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Should -BeTrue

        $item = Get-Item -LiteralPath $script:linkPath -Force
        if ($script:canCreateSymbolicLink) {
            $item.LinkType | Should -Be 'SymbolicLink'
            [System.IO.Path]::GetFullPath($item.ResolveLinkTarget($true).FullName) |
                Should -Be ([System.IO.Path]::GetFullPath($script:sourcePath))
        }
        else {
            $item.LinkType | Should -Be 'HardLink'
        }
        [System.IO.File]::ReadAllText($script:linkPath) | Should -Be "alpha`n"
    }

    It 'is idempotent — a second call reports unchanged' {
        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Should -BeTrue
        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Should -BeFalse
    }

    It 'replaces a plain file with identical content (an old generated copy) with a link' {
        # Load-bearing for comment:none entries: content equality alone must never count as current.
        [System.IO.File]::WriteAllText($script:linkPath, "alpha`n")

        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Should -BeTrue
        (Get-Item -LiteralPath $script:linkPath -Force).LinkType | Should -Not -BeNullOrEmpty
    }

    It 'reflects a source edit through the link' {
        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Out-Null

        # In-place write to the source (an editor save) — the link is the same file, so it follows.
        [System.IO.File]::WriteAllText($script:sourcePath, "beta`n")
        [System.IO.File]::ReadAllText($script:linkPath) | Should -Be "beta`n"
        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Should -BeFalse
    }

    It 'heals a hard link orphaned by a git-style rewrite of the source' {
        # A hard link (created directly — no privilege needed) goes stale when the source is replaced by a
        # new file (what git checkout/pull does): the old bytes stay behind under the link.
        New-Item -ItemType HardLink -Path $script:linkPath -Target $script:sourcePath | Out-Null
        [System.IO.File]::Delete($script:sourcePath)
        [System.IO.File]::WriteAllText($script:sourcePath, "beta`n")
        [System.IO.File]::ReadAllText($script:linkPath) | Should -Be "alpha`n"

        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Should -BeTrue
        [System.IO.File]::ReadAllText($script:linkPath) | Should -Be "beta`n"
    }

    It 're-points a symbolic link at the wrong target' {
        if (-not $script:canCreateSymbolicLink) {
            Set-ItResult -Skipped -Because 'symbolic_link_privilege_missing'; return
        }
        $wrongSource = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '-wrong.txt')
        [System.IO.File]::WriteAllText($wrongSource, "wrong`n")
        New-Item -ItemType SymbolicLink -Path $script:linkPath -Target $wrongSource | Out-Null

        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Should -BeTrue
        [System.IO.File]::ReadAllText($script:linkPath) | Should -Be "alpha`n"
    }

    It '-DryRun reports the would-be link without touching the filesystem' {
        [System.IO.File]::WriteAllText($script:linkPath, "alpha`n")

        Set-FileLink -Path $script:linkPath -Target $script:sourcePath -DryRun | Should -BeTrue
        (Get-Item -LiteralPath $script:linkPath -Force).LinkType | Should -BeNullOrEmpty
    }

    It '-DryRun reports a current link as unchanged' {
        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Out-Null
        Set-FileLink -Path $script:linkPath -Target $script:sourcePath -DryRun | Should -BeFalse
    }

    It 'deleting the link leaves the source untouched' {
        Set-FileLink -Path $script:linkPath -Target $script:sourcePath | Out-Null

        [System.IO.File]::Delete($script:linkPath)
        [System.IO.File]::ReadAllText($script:sourcePath) | Should -Be "alpha`n"
    }

    It 'throws when the target source does not exist' {
        { Set-FileLink -Path $script:linkPath -Target (Join-Path $TestDrive 'missing.txt') } | Should -Throw
    }
}
