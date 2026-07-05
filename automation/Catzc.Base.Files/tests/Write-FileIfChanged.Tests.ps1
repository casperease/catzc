# cspell:ignore nbeta  -- the escape-sequence artifact in the "alpha`nbeta" fixture strings
Describe 'Write-FileIfChanged' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N') + '.txt')
    }

    It 'creates a missing file and reports changed' {
        Write-FileIfChanged $target "alpha`nbeta" | Should -BeTrue
        [System.IO.File]::Exists($target) | Should -BeTrue
    }

    It 'writes canonical text: UTF-8 no BOM, LF endings, exactly one trailing newline' {
        Write-FileIfChanged $target "alpha`r`nbeta`r`n`r`n" | Out-Null

        $bytes = [System.IO.File]::ReadAllBytes($target)
        # No BOM
        ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) | Should -BeFalse
        # No CR anywhere, single trailing LF
        [System.IO.File]::ReadAllText($target) | Should -BeExactly "alpha`nbeta`n"
    }

    It 'is idempotent: a second identical write reports unchanged' {
        Write-FileIfChanged $target "alpha`nbeta" | Should -BeTrue
        Write-FileIfChanged $target "alpha`nbeta" | Should -BeFalse
    }

    It 'treats a CRLF on-disk file with the same logical content as current (no rewrite)' {
        $utf8 = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($target, "alpha`r`nbeta`r`n", $utf8)

        Write-FileIfChanged $target "alpha`nbeta`n" | Should -BeFalse
        # Untouched: the CRLF bytes are still on disk
        [System.IO.File]::ReadAllText($target) | Should -BeExactly "alpha`r`nbeta`r`n"
    }

    It 'rewrites on a real content change' {
        Write-FileIfChanged $target "alpha`n" | Out-Null
        Write-FileIfChanged $target "beta`n" | Should -BeTrue
        [System.IO.File]::ReadAllText($target) | Should -BeExactly "beta`n"
    }

    It '-DryRun reports a would-be change without writing' {
        Write-FileIfChanged $target 'alpha' -DryRun | Should -BeTrue
        [System.IO.File]::Exists($target) | Should -BeFalse
    }

    It '-DryRun reports current content as unchanged' {
        Write-FileIfChanged $target 'alpha' | Out-Null
        Write-FileIfChanged $target 'alpha' -DryRun | Should -BeFalse
    }

    It 'creates a missing parent directory' {
        $nested = Join-Path $TestDrive 'sub/dir/file.txt'
        Write-FileIfChanged $nested 'alpha' | Should -BeTrue
        [System.IO.File]::Exists($nested) | Should -BeTrue
    }

    It 'canonicalises empty content to a single newline' {
        Write-FileIfChanged $target '' | Should -BeTrue
        [System.IO.File]::ReadAllText($target) | Should -BeExactly "`n"
    }
}
