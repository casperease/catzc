Describe 'Format-FileMeta and Test-FileMeta' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS', 'ADR-REPO-FORMAT-METAIMPRINT' {
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
                    'file-role' = @{ keys = @('role') }
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

    It 'leaves a file with a key no kind owns unchanged and reports it' {
        $path = Join-Path $script:widgetRoot 'docs/widget.md'
        $text = "---`ncatzc:`n  immutable:`n    surprise: 1`n---`n# docs/widget.md`n"
        [System.IO.File]::WriteAllText($path, $text)
        Format-FileMeta -RepositoryRoot $script:widgetRoot | Should -Not -Contain 'docs/widget.md'
        [System.IO.File]::ReadAllText($path) | Should -BeExactly $text
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Message -like "docs/widget.md needs a decision by hand: 'catzc.immutable.surprise'*" -and $Warning
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
