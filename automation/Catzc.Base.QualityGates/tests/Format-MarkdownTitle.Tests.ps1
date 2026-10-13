Describe 'Format-MarkdownTitle and Test-MarkdownTitle' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#6' {
    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# widget`r`n`r`nBody.`r`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "# docs/gadget.md`n")
        Mock Get-MarkdownTitleScope { , [string[]] @('docs/widget.md', 'docs/gadget.md') } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
        $script:reportBase = Join-Path $script:widgetRoot 'reports'
        Mock Get-AdrCitationPath { @{ 'ADR-TST-WIDGET' = 'docs/widget.md' } } -ModuleName Catzc.Base.QualityGates
    }

    It 'titles the wrong file only, keeping its line endings and writing no BOM' {
        $changed = Format-MarkdownTitle -RepositoryRoot $script:widgetRoot
        $changed | Should -Be @('docs/widget.md')
        $bytes = [System.IO.File]::ReadAllBytes((Join-Path $script:widgetRoot 'docs/widget.md'))
        $bytes[0] | Should -Be ([byte] [char] '#')
        [System.Text.Encoding]::UTF8.GetString($bytes) | Should -Be (('# docs/widget.md', '', '`widget`', '', 'Body.', '') -join "`r`n")
    }

    It 'changes nothing on a second run' {
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot | Out-Null
        @(Format-MarkdownTitle -RepositoryRoot $script:widgetRoot) | Should -BeNullOrEmpty
    }

    It 'writes nothing under -DryRun and reports what would change' {
        $result = Format-MarkdownTitle -RepositoryRoot $script:widgetRoot -DryRun -PassThru
        $result.ChangedFiles | Should -Be @('docs/widget.md')
        $result.FileCount | Should -Be 2
        $result.DryRun | Should -BeTrue
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/widget.md')) | Should -BeLike '# widget*'
    }

    It 'flags the untitled file and points at the formatter' {
        { Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } |
            Should -Throw "Test-MarkdownTitle failed: 1 issue(s)*docs/widget.md:1 ``[Wrong``] expected '# docs/widget.md', found '# widget' — run Format-MarkdownTitle*"
    }

    It 'returns the result with the file count under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        $result = Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase -PassThru
        $result.Subject | Should -Be 'markdown-title'
        $result.IssueCount | Should -Be 1
        $result.FileCount | Should -Be 2
        Test-Path (Join-Path $result.ReportPath 'markdown-title.md') | Should -BeTrue
    }

    It 'passes once the files are titled' {
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot | Out-Null
        { Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } | Should -Not -Throw
    }
}

Describe 'Format-MarkdownTitle and Test-MarkdownTitle — headings' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#7' {
    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# docs/widget.md`n`n## Validation (``Assert-Widget``)`n`nBody.`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "# docs/gadget.md`n`nSee [validation](widget.md#validation-assert-widget).`n")
        Mock Get-MarkdownTitleScope { , [string[]] @('docs/widget.md', 'docs/gadget.md') } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
        $script:reportBase = Join-Path $script:widgetRoot 'reports'
        Mock Get-AdrCitationPath { @{} } -ModuleName Catzc.Base.QualityGates
    }

    It 'moves the trailing group out and re-points the link to the renamed anchor' {
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot | Should -Be @('docs/gadget.md', 'docs/widget.md')
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/widget.md')) | Should -Be "# docs/widget.md`n`n## Validation`n`n``Assert-Widget```n`nBody.`n"
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/gadget.md')) | Should -Be "# docs/gadget.md`n`nSee [validation](widget.md#validation).`n"
        (Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase -PassThru).IssueCount | Should -Be 0
    }

    It 're-points links in the whole scope when -Path narrows the check' {
        # Filter on the bound parameters, not on $Path: an unbound -Path resolves $Path from an outer scope (the test
        # runner's own $Path), which would send the engine's whole-scope call to this narrowed mock too.
        Mock Get-MarkdownTitleScope { , [string[]] @('docs/widget.md') } -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $PesterBoundParameters.ContainsKey('Path')
        }
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot -Path (Join-Path $script:widgetRoot 'docs/widget.md') | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/gadget.md')) | Should -BeLike '*widget.md#validation)*'
    }

    It 'flags a duplicate anchor, and the formatter leaves it for the author' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "# docs/gadget.md`n`n## Gadget`n`n### Gadget`n")
        { Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } |
            Should -Throw '*docs/gadget.md:5 `[Duplicate`]*reword it by hand*'
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/gadget.md')) | Should -Be "# docs/gadget.md`n`n## Gadget`n`n### Gadget`n"
    }
}
