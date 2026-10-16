<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
    folder: tests
    name: format-markdown-title-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Format-MarkdownTitle.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#35
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-FORMAT#{6,7}
---
#>

Describe 'Format-MarkdownTitle and Test-MarkdownTitle' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#6' {
    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# docs/widget.md`r`n`r`n``Widget```r`n`r`nBody.`r`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "# Gadget`n")
        Mock Get-MarkdownScope { , [string[]] @('docs/widget.md', 'docs/gadget.md') } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
        $script:reportBase = Join-Path $script:widgetRoot 'reports'
        Mock Get-AdrCitationPath { @{ 'ADR-TST-WIDGET' = 'docs/widget.md' } } -ModuleName Catzc.Base.QualityGates
    }

    It 'retitles the path-titled file only, keeping its line endings and writing no BOM' {
        $changed = Format-MarkdownTitle -RepositoryRoot $script:widgetRoot
        $changed | Should -Be @('docs/widget.md')
        $bytes = [System.IO.File]::ReadAllBytes((Join-Path $script:widgetRoot 'docs/widget.md'))
        $bytes[0] | Should -Be ([byte] [char] '#')
        [System.Text.Encoding]::UTF8.GetString($bytes) | Should -Be (('# Widget', '', 'Body.', '') -join "`r`n")
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
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/widget.md')) | Should -BeLike '# docs/widget.md*'
    }

    It 'flags the path-titled file and points at the formatter' {
        { Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } |
            Should -Throw "Test-MarkdownTitle failed: 1 issue(s)*docs/widget.md:1 ``[PathTitle``] expected '# Widget', found '# docs/widget.md' — run Format-MarkdownTitle*"
    }

    It 'flags a file with no title for a person to write, and the formatter leaves it' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "# docs/gadget.md`n`nBody.`n")
        { Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } |
            Should -Throw '*docs/gadget.md:1 `[Untitled`]*write the title by hand*'
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot | Should -Be @('docs/widget.md')
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/gadget.md')) | Should -Be "# docs/gadget.md`n`nBody.`n"
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Message -like 'docs/gadget.md:1 needs a decision by hand (Untitled)*' -and $Warning
        }
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
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# Widget`n`n## Validation (``Assert-Widget``)`n`nBody.`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "# Gadget`n`nSee [validation](widget.md#validation-assert-widget).`n")
        Mock Get-MarkdownScope { , [string[]] @('docs/widget.md', 'docs/gadget.md') } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
        $script:reportBase = Join-Path $script:widgetRoot 'reports'
        Mock Get-AdrCitationPath { @{} } -ModuleName Catzc.Base.QualityGates
    }

    It 'moves the trailing group out and re-points the link to the renamed anchor' {
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot | Should -Be @('docs/gadget.md', 'docs/widget.md')
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/widget.md')) | Should -Be "# Widget`n`n## Validation`n`n``Assert-Widget```n`nBody.`n"
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/gadget.md')) | Should -Be "# Gadget`n`nSee [validation](widget.md#validation).`n"
        (Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase -PassThru).IssueCount | Should -Be 0
    }

    It 're-points links in the whole scope when -Path narrows the check' {
        Mock Get-MarkdownScope { , [string[]] @('docs/widget.md') } -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $PesterBoundParameters.ContainsKey('Path')
        }
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot -Path (Join-Path $script:widgetRoot 'docs/widget.md') | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/gadget.md')) | Should -BeLike '*widget.md#validation)*'
    }

    It 'flags a duplicate anchor, and the formatter leaves it for the author' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "# Gizmo`n`n## Gadget`n`n### Gadget`n")
        { Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } |
            Should -Throw '*docs/gadget.md:5 `[Duplicate`]*reword it by hand*'
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/gadget.md')) | Should -Be "# Gizmo`n`n## Gadget`n`n### Gadget`n"
    }
}

Describe 'Format-MarkdownTitle and Test-MarkdownTitle — contract assets' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#6', 'ADR-REPO-CONTRACT#6' {
    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:contractAsset = 'contracts/widget/0.0.0/Gadget/.github/README.md'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'contracts/widget/0.0.0/Gadget/.github')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# docs/widget.md`n`n``Widget```n")
        # An empty presence asset: a stamped title would turn it into a fragment the real file fails.
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot $script:contractAsset), '')
        # The scope itself runs; git is the one boundary (tracked files and the declared classes).
        Mock Get-GitTrackedPath { 'docs/widget.md', 'contracts/widget/0.0.0/Gadget/.github/README.md' } -ModuleName Catzc.Base.QualityGates
        Mock Get-GitAttributeValue {
            @{ 'contracts/widget/0.0.0/Gadget/.github/README.md' = @{ 'catzc-contract' = 'set' } }
        } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
        $script:reportBase = Join-Path $script:widgetRoot 'reports'
        Mock Get-AdrCitationPath { @{} } -ModuleName Catzc.Base.QualityGates
    }

    It 'titles the authored file and leaves the contract asset untouched' {
        Format-MarkdownTitle -RepositoryRoot $script:widgetRoot | Should -Be @('docs/widget.md')
        [System.IO.File]::ReadAllBytes((Join-Path $script:widgetRoot $script:contractAsset)).Length | Should -Be 0
    }

    It 'never flags the contract asset' {
        $result = Test-MarkdownTitle -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase -PassThru
        $result.FileCount | Should -Be 1
        $result.Issues | Should -Not -BeLike "*$($script:contractAsset)*"
    }
}
