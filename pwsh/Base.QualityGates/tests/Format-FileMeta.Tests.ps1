[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
    Justification = 'The fixture fact processors keep the State, Path and Kind parameters the engine passes by name, though they read fewer')]
param()

Describe 'Format-FileMeta and Test-FileMeta' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS', 'ADR-REPO-FORMAT-METAIMPRINT' {
    BeforeAll {
        InModuleScope Catzc.Base.QualityGates {
            function script:Get-WidgetRoleFileMetaFact {
                param($State, $Path, $Kind)
                [ordered]@{ role = "$((Get-FileKind $Path).Class)" }
            }
            function script:Get-WidgetTintFileMetaFact {
                param($State, $Path, $Kind)
                [ordered]@{ tint = [regex]::Match("$($State.Body)", '(?m)^Tint (\w+)\.').Groups[1].Value }
            }
        }
    }

    AfterAll {
        InModuleScope Catzc.Base.QualityGates {
            Remove-Item Function:\Get-WidgetRoleFileMetaFact, Function:\Get-WidgetTintFileMetaFact -ErrorAction Ignore
        }
    }

    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'),
            "# docs/widget.md`r`n`r`nTint blue.`r`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/gadget.md'),
            "---`nname: gadget`ncatzc:`n  config:`n    gadgets:`n      one: 1`n---`n# docs/gadget.md`n")
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
                head_policy = @{ default = 'facts' }
                kinds       = [ordered]@{
                    'widget-role' = @{ keys = @('role') }
                    'widget-tint' = @{ keys = @('tint') }
                }
            })
        # Not named $config: that is Get-Config's own -Config parameter inside the mock.
        Mock Get-Config { $script:registry } -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'file-meta' }
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

    It 'skips a file it left clean on the next run, and checks it again under -NoCache' -Tag 'ADR-AUTO-CACHE-CROSSSESSIONFILES' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq 'Checking the meta block of 0 file(s) (2 unchanged since their last check)...' }
        Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun -NoCache | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Message -eq 'Checking the meta block of 2 file(s) (0 unchanged since their last check)...' }
    }

    It 'removes a head an authored file still carries from an earlier shape, docs edge and header note alike' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        $path = Join-Path $script:widgetRoot 'docs/widget.md'
        $body = ([System.IO.File]::ReadAllText($path) -replace "`r", '')
        [System.IO.File]::WriteAllText($path, "---`ncatzc:`n  docs: pages/widget.md.md`n  header: `"generated`"`n---`n`n$body")
        $script:registry = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{})
        Format-FileMeta -RepositoryRoot $script:widgetRoot -NoCache | Out-Null
        ([System.IO.File]::ReadAllText($path) -replace "`r", '') | Should -Not -BeLike '*catzc:*' -Because 'an authored file carries no head'
    }

    It 'never records a file the dry run would change as clean' -Tag 'ADR-AUTO-CACHE-CROSSSESSIONFILES' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun | Out-Null
        Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 2 -Exactly -ParameterFilter { $Message -eq 'Checking the meta block of 2 file(s) (0 unchanged since their last check)...' }
    }

    It 'imprints the facts above a file with no front matter, keeping its line endings and writing no BOM' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Should -Contain 'docs/widget.md'
        $bytes = [System.IO.File]::ReadAllBytes((Join-Path $script:widgetRoot 'docs/widget.md'))
        $bytes[0] | Should -Be ([byte] [char] '-')
        $text = [System.Text.Encoding]::UTF8.GetString($bytes)
        $text |
            Should -BeLike "---`r`ncatzc:`r`n  role: gadget`r`n  tint: blue`r`n---`r`n`r`n# docs/widget.md*"
    }

    It 'keeps the authored config part and the other front matter keys' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Out-Null
        $text = [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/gadget.md'))
        $text |
            Should -BeExactly "---`nname: gadget`ncatzc:`n  role: gadget`n  config:`n    gadgets:`n      one: 1`n---`n# docs/gadget.md`n"
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
        [System.IO.File]::WriteAllText($path, [System.IO.File]::ReadAllText($path).Replace('Tint blue.', 'Tint red.'))
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Should -Be @('docs/widget.md')
        [System.IO.File]::ReadAllText($path) | Should -BeLike '*  tint: red*'
    }

    It 'writes nothing under -DryRun and reports what would change' {
        $result = Format-FileMeta -RepositoryRoot $script:widgetRoot -DryRun -PassThru
        $result.ChangedFiles | Should -Be @('docs/gadget.md', 'docs/widget.md')
        $result.FileCount | Should -Be 2
        $result.DryRun | Should -BeTrue
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/widget.md')) |
            Should -BeLike '# docs/widget.md*'
    }

    It 'drops a first-level key no kind owns, the old edges part included, and keeps the authored config' -Tag 'ADR-REPO-FILEMETA-KINDSCOPE' {
        $path = Join-Path $script:widgetRoot 'docs/gadget.md'
        [System.IO.File]::WriteAllText($path,
            "---`ncatzc:`n  surprise: 1`n  edges:`n    cites:`n      - ADR-GADGET-SPIN`n  config:`n    gadgets:`n      one: 1`n---`n# docs/gadget.md`n")
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Should -Contain 'docs/gadget.md'
        [System.IO.File]::ReadAllText($path) |
            Should -BeExactly "---`ncatzc:`n  role: gadget`n  config:`n    gadgets:`n      one: 1`n---`n# docs/gadget.md`n"
    }

    It 'flags the drifted files and points at the formatter' {
        { Test-FileMeta -RepositoryRoot $script:widgetRoot -OutputFolder $script:reportBase } |
            Should -Throw "Test-FileMeta failed: 2 issue(s)*docs/widget.md:1 ``[Drift``] expected 'the imprinted meta block*run Format-FileMeta*"
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

    It 'gives an authored page with a fact its head, and strips the head of one whose facts are all empty' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        $script:registry = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'widget-tint' = @{ keys = @('tint') } } })
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/plain.md'),
            "---`ncatzc:`n  immutable:`n    with_body_sha: 0123456789ab`n---`n`n# docs/plain.md`n`nNo shade here.`n")
        $script:scope = @(
            [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }
            [pscustomobject]@{ Path = 'docs/plain.md'; Carrier = $script:front }
        )
        Format-FileMeta -RepositoryRoot $script:widgetRoot -NoCache | Sort-Object | Should -Be @('docs/plain.md',
            'docs/widget.md')
        $tinted = [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/widget.md')) -replace "`r", ''
        $tinted | Should -BeLike "---`ncatzc:`n  tint: blue`n---`n`n# docs/widget.md*"
        $tinted |
            Should -Not -BeLike '*with_body_sha*' -Because 'only the generated-head writer emits a body hash, never the imprint of an authored file'
        [System.IO.File]::ReadAllText((Join-Path $script:widgetRoot 'docs/plain.md')) |
            Should -BeExactly "# docs/plain.md`n`nNo shade here.`n"
    }
}

Describe 'Format-FileMeta on the repository' -Tag 'L2', 'integrity', 'source-only', 'ADR-REPO-FILEMETA-HEADPOLICY' {
    It 'leaves a generated page''s head to its generator: the page is outside the scope, so a run changes nothing' -Tag 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        $before = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'docs/drs/index.md'))
        $result = Format-FileMeta -Path 'docs/drs/index.md' -DryRun -NoCache -PassThru
        $result.FileCount | Should -Be 0
        $result.ChangedCount | Should -Be 0
        [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'docs/drs/index.md')) | Should -BeExactly $before
    }
}

Describe 'Format-FileMeta over its real scope' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-HEADPOLICY' {
    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        $script:widget = Join-Path $script:widgetRoot 'docs/widget.md'
        [System.IO.File]::WriteAllText($script:widget, "---`ncatzc:`n  docs: pages/widget.md`n  header: `"generated`"`n---`n`n# docs/widget.md`n")
        # Only the git boundary is stood in: the scope itself, its carriers and its policy run as shipped.
        Mock Get-GitTrackedPath { 'docs/widget.md' } -ModuleName Catzc.Base.QualityGates
        Mock Get-ContentExemptPath { , [string[]] @() } -ModuleName Catzc.Base.QualityGates
        Mock Get-GitAttributeValue { @{} } -ModuleName Catzc.Base.QualityGates
        Mock Assert-SourceTree { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'empties the head an authored file still carries, though no kind selects it' {
        Format-FileMeta -RepositoryRoot $script:widgetRoot -NoCache | Should -Be @('docs/widget.md')
        ([System.IO.File]::ReadAllText($script:widget) -replace "`r", '') | Should -BeExactly "# docs/widget.md`n"
    }
}
