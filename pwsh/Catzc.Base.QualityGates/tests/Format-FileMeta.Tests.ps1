<#
---
catzc:
  immutable:
    with_body_sha: e7379209f7ab
  edges:
    code: pwsh/Catzc.Base.QualityGates/Format-FileMeta.ps1
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
      - ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-FORMAT-METAIMPRINT
---
#>

Describe 'Format-FileMeta and Test-FileMeta' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS', 'ADR-REPO-FORMAT-METAIMPRINT' {
    BeforeAll {
        # A fixture kind with a fixture processor, so the commands are proven on a place fact of their own.
        InModuleScope Catzc.Base.QualityGates {
            function script:Get-WidgetRoleFileMetaFact {
                param($State, $Path, $Kind)
                [ordered]@{ role = "$((Get-FileKind $Path).Class)" }
            }
        }
    }

    AfterAll {
        InModuleScope Catzc.Base.QualityGates {
            Remove-Item Function:\Get-WidgetRoleFileMetaFact -ErrorAction Ignore
        }
    }

    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# docs/widget.md`r`n`r`nSee ADR-GADGET-SPIN.`r`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "---`nname: gadget`ncatzc:`n  config:`n    gadgets:`n      one: 1`n---`n# docs/gadget.md`n")
        $script:front = [Catzc.Base.Languages.FileCarriersConfig]::new(@{ carriers = [ordered]@{ markdown = @{ carrier = 'front-matter' } } }).Find('markdown')
        $script:scope = @(
            [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }
            [pscustomobject]@{ Path = 'docs/gadget.md'; Carrier = $script:front }
        )
        Mock Get-FileMetaScope { $script:scope } -ModuleName Catzc.Base.QualityGates
        $script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{ gadget = [ordered]@{ definition = 'A gadget file.'; files = @('docs/**') } }
            })
        Mock Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'file-kinds' } { $script:kinds }
        $script:registry = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                head_policy = @{ default = 'required' }
                kinds       = [ordered]@{
                    'body-sha'  = @{ keys = @('with_body_sha') }
                    'widget-role' = @{ keys = @('role') }
                    'adr-codes' = @{ keys = @('cites'); section = 'edges' }
                }
            })
        # Not named $config: that is Get-Config's own -Config parameter inside the mock.
        Mock Get-Config { $script:registry } -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'file-meta' }
        # The one code the fixtures cite, registered with ten rules, so the adr-codes kind keeps it.
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Docs.AdrCitationMap]::new(@{ 'ADR-GADGET' = @{ path = 'docs/adr/gadget.md'; rules = [string[]] @('ADR-GADGET-TURN', 'ADR-GADGET-SPIN', 'ADR-GADGET-FOLD', 'ADR-GADGET-LIFT') } }, @())
        }
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
        $script:reportBase = Join-Path $script:widgetRoot 'reports'
        $script:outRoot = Join-Path $script:widgetRoot 'out'
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { $script:outRoot }
    }

    It 'announces how many files it checks before it checks them' -Tag 'ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Message -eq 'Formatting the meta block of 2 file(s) (0 unchanged since their last check)...'
        }
    }

    It 'skips a file it left clean on the next run, and checks it again under -NoCache' -Tag 'ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq 'Checking the meta block of 0 file(s) (2 unchanged since their last check)...' }
        Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun -NoCache | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq 'Checking the meta block of 2 file(s) (0 unchanged since their last check)...' }
    }

    It 'checks a cached file again when only its comment page changes, and refreshes its head from the page' -Tag 'ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS' {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'comment-pages' } {
            [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'docs'; docs = 'docs/pages' }) })
        }
        # The cites processor reads the page under the loaded repository root.
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:widgetRoot }
        $page = Join-Path $script:widgetRoot 'docs/pages/widget.md.md'
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($page)) | Out-Null
        [System.IO.File]::WriteAllText($page, "# docs/widget.md`n")
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        $path = Join-Path $script:widgetRoot 'docs/widget.md'
        $before = [System.IO.File]::ReadAllText($path)

        [System.IO.File]::WriteAllText($page, "# docs/widget.md`n`nSee ADR-GADGET-FOLD.`n")
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Should -Be @('docs/widget.md')
        [System.IO.File]::ReadAllText($path) | Should -Not -BeExactly $before
        [System.IO.File]::ReadAllText($path) | Should -BeLike '*- ADR-GADGET-SPIN*- ADR-GADGET-FOLD*'
    }

    It 'never records a file the dry run would change, or one with a section no part owns, as clean' -Tag 'ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'), "---`ncatzc:`n  surprise: 1`n---`n# docs/gadget.md`n")
        Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun | Out-Null
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Message -eq 'Formatting the meta block of 2 file(s) (0 unchanged since their last check)...' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Message -eq 'Checking the meta block of 1 file(s) (1 unchanged since their last check)...' }
    }

    It 'imprints the place facts and the edges above a file with no front matter, keeping its line endings and writing no BOM' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Should -Contain 'docs/widget.md'
        $bytes = [System.IO.File]::ReadAllBytes((Join-Path $script:widgetRoot 'docs/widget.md'))
        $bytes[0] | Should -Be ([byte] [char] '-')
        $text = [System.Text.Encoding]::UTF8.GetString($bytes)
        $text | Should -BeLike "---`r`ncatzc:`r`n  immutable:`r`n    with_body_sha: *`r`n    role: gadget`r`n  edges:`r`n    cites:`r`n      - ADR-GADGET-SPIN`r`n---`r`n`r`n# docs/widget.md*"
    }

    It 'keeps the authored config part and the other front matter keys' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        $text = [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/gadget.md')) -replace 'with_body_sha: "?[0-9a-f]{12}"?', 'with_body_sha: HASH'
        $text | Should -BeExactly "---`nname: gadget`ncatzc:`n  immutable:`n    with_body_sha: HASH`n    role: gadget`n  config:`n    gadgets:`n      one: 1`n---`n# docs/gadget.md`n"
    }

    It 'changes nothing on a second run' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        $before = [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/widget.md'))
        @(Format-FileMeta -RepositoryRoot $script:widgetRoot) | Should -BeNullOrEmpty
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/widget.md')) | Should -BeExactly $before
    }

    It 'rewrites a stale fact when the body changes' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        $path = Join-Path $script:widgetRoot 'docs/widget.md'
        [System.IO.File]::WriteAllText($path, [System.IO.File]::ReadAllText($path).Replace('ADR-GADGET-SPIN', 'ADR-GADGET-FOLD'))
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Should -Be @('docs/widget.md')
        [System.IO.File]::ReadAllText($path) | Should -BeLike '*- ADR-GADGET-FOLD*'
    }

    It 'writes nothing under -DryRun and reports what would change' {
        $result = Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun -PassThru
        $result.ChangedFiles | Should -Be @('docs/gadget.md', 'docs/widget.md')
        $result.FileCount | Should -Be 2
        $result.DryRun | Should -BeTrue
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/widget.md')) | Should -BeLike '# docs/widget.md*'
    }

    It 'leaves a file with a section no part owns unchanged and reports it' {
        $path = Join-Path $script:widgetRoot 'docs/widget.md'
        $text = "---`ncatzc:`n  surprise: 1`n---`n# docs/widget.md`n"
        [System.IO.File]::WriteAllText($path, $text)
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Should -Not -Contain 'docs/widget.md'
        [System.IO.File]::ReadAllText($path) | Should -BeExactly $text
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Message -like "docs/widget.md needs a decision by hand: 'catzc.surprise'*" -and $Warning
        }
    }

    It 'flags the drifted files and points at the formatter' {
        { Test-FileMeta -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } |
            Should -Throw "Test-FileMeta failed: 2 issue(s)*docs/widget.md:1 ``[Drift``] expected 'the imprinted meta block'*run Format-FileMeta*"
    }

    It 'flags a key no kind owns and says where it belongs' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "---`ncatzc:`n  other: 1`n---`n# docs/widget.md`n")
        { Test-FileMeta -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } |
            Should -Throw "*docs/widget.md:0 ``[Unowned``] expected 'immutable, edges or config', found 'catzc.other' — move it under config, or remove it*"
    }

    It 'returns the result with the file count under -PassThru' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $result = Test-FileMeta -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase -PassThru
        $result.Subject | Should -Be 'file-meta'
        $result.IssueCount | Should -Be 2
        $result.Facts['FileCount'] | Should -Be 2
        Test-Path (Join-Path $result.ReportPath 'file-meta.md') | Should -BeTrue
    }

    It 'passes once the files are imprinted' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        { Test-FileMeta -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } | Should -Not -Throw
    }
}
