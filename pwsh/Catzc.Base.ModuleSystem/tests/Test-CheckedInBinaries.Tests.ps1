Describe 'Test-CheckedInBinaries' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive 'repo'
        $vendor = Join-Path $root 'widgets/.vendor/Widget'
        [void][System.IO.Directory]::CreateDirectory($vendor)
        [System.IO.File]::WriteAllBytes((Join-Path $vendor 'widget.dll'), [byte[]](77, 90, 0, 1))
        [System.IO.File]::WriteAllBytes((Join-Path $vendor 'gadget.dll'), [byte[]](77, 90, 0, 2))
        [System.IO.File]::WriteAllText((Join-Path $vendor 'widget.psd1'), '@{ }')
        # A binary outside pwsh/: the gate scans every tracked file, not just the vendored and compiled trees.
        $docs = Join-Path $root 'docs'
        [void][System.IO.Directory]::CreateDirectory($docs)
        [System.IO.File]::WriteAllBytes((Join-Path $docs 'widget.pdf'), [byte[]](37, 80, 68, 70, 0, 3))
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.ModuleSystem { Join-Path $TestDrive 'repo' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        $script:eol = @{ 'widget.dll' = '-text'; 'gadget.dll' = '-text'; 'widget.pdf' = '-text' }
        $script:attr = @{ 'widget.dll' = 'set'; 'gadget.dll' = 'set'; 'widget.pdf' = 'set' }
        # The attr/ column as git prints it; it may hold spaces (`text eol=lf`).
        $script:attrColumn = @{ 'widget.pdf' = '-text' }
        Mock Invoke-Executable -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Command -match ' ls-files ' } {
            # git separates the EOL columns from the path with a tab.
            $tab = [char]9
            $lines = @(
                "i/$($eol['widget.dll'])  w/-text attr/-text      ${tab}widgets/.vendor/Widget/widget.dll"
                "i/$($eol['gadget.dll'])  w/-text attr/-text      ${tab}widgets/.vendor/Widget/gadget.dll"
                "i/lf    w/lf    attr/                 ${tab}widgets/.vendor/Widget/widget.psd1"
                "i/-text w/      attr/                 ${tab}widgets/.vendor/Widget/gone.dll"
                "i/$($eol['widget.pdf'])  w/-text attr/$($attrColumn['widget.pdf'])      ${tab}docs/widget.pdf"
            )
            [pscustomobject]@{ Output = $lines -join "`n" }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Command -match ' check-attr ' } {
            $lines = @(
                "widgets/.vendor/Widget/widget.dll: binary: $($attr['widget.dll'])"
                "widgets/.vendor/Widget/gadget.dll: binary: $($attr['gadget.dll'])"
                "docs/widget.pdf: binary: $($attr['widget.pdf'])"
            )
            [pscustomobject]@{ Output = $lines -join "`n" }
        }
    }

    It 'passes when every binary is stored as -text under an explicit binary rule, and counts only the binaries' {
        $result = Test-CheckedInBinaries -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Binaries'] | Should -Be 3
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter {
            $Command -match ' check-attr binary -- "widgets/.vendor/Widget/widget.dll" "widgets/.vendor/Widget/gadget.dll" "docs/widget.pdf"$'
        }
    }

    It 'lists every tracked file, not only the vendored and compiled trees' {
        $null = Test-CheckedInBinaries -OutputFolder $out -PassThru
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter {
            $Command -match ' ls-files --eol$'
        }
    }

    It 'still finds a binary whose attribute column holds spaces, and names it stored as text' {
        $eol['widget.pdf'] = 'lf'
        $attrColumn['widget.pdf'] = 'text eol=lf'
        $attr['widget.pdf'] = 'unspecified'
        $result = Test-CheckedInBinaries -OutputFolder $out -PassThru
        $result.Issues | Should -Contain 'docs/widget.pdf: stored as text, not binary (git index eol = lf)'
        $result.Issues | Should -Contain 'docs/widget.pdf: no explicit binary .gitattributes rule'
    }

    It 'throws once naming a binary stored as text and one with no binary rule' {
        $eol['widget.dll'] = 'crlf'
        $attr['gadget.dll'] = 'unspecified'
        $thrown = { Test-CheckedInBinaries -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-CheckedInBinaries failed: 2 issue(s)*'
        $message | Should -Match 'widget.dll: stored as text, not binary \(git index eol = crlf\)'
        $message | Should -Match 'gadget.dll: no explicit binary .gitattributes rule'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        $eol['gadget.dll'] = 'mixed'
        $result = Test-CheckedInBinaries -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'checked-in-binaries'
        $result.Issues | Should -HaveCount 1
    }
}

Describe 'Checked-in binaries are stored as binary, not text' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:repoRoot = Get-RepositoryRoot
        $script:skip = $null

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

        $script:result = $null
        if (-not $script:skip) {
            $script:result = Test-CheckedInBinaries -PassThru -OutputFolder (Join-Path $TestDrive 'checked-in-binaries')
        }
    }

    It 'finds checked-in binary files to verify (guards against a vacuous pass)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.Facts['Binaries'] | Should -BeGreaterThan 0
    }

    It 'stores every binary byte-exact under an explicit binary attribute' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
