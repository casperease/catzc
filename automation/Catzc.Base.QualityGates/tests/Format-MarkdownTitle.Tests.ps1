Describe 'Format-MarkdownTitle and Test-MarkdownTitle' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#6' {
    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# widget`r`n`r`nBody.`r`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "# docs/gadget.md`n")
        Mock Get-MarkdownTitleScope { , [string[]] @('docs/widget.md', 'docs/gadget.md') } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
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

    It 'gates the untitled file and points at the formatter' {
        { Test-MarkdownTitle -RepositoryRoot $script:widgetRoot } | Should -Throw "*run Format-MarkdownTitle*docs/widget.md:1 expected '# docs/widget.md', found '# widget'*"
    }

    It 'passes once the files are titled' {
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot | Out-Null
        (Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -PassThru).ViolationCount | Should -Be 0
    }
}
