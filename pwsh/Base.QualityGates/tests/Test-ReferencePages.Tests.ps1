Describe 'Test-ReferencePages' -Tag 'L0', 'logic', 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
    BeforeEach {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'comment-pages' } {
            [Catzc.Base.CodeMeta.CommentPagesConfig]::new([ordered]@{
                    pages    = @([ordered]@{ source = 'widgets/*'; docs = 'docs/references/widgets' })
                    articles = @('docs/references/widgets/overview.md')
                })
        }
        $script:outputFolder = Join-Path $TestDrive 'report'
    }

    It 'passes a tree whose every page maps back to one source, a module article, or a listed article' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'widgets/Gadget.Kit/Get-Gadget.ps1', 'widgets/Gadget.Kit/tests/Get-Gadget.Tests.ps1',
            'docs/references/widgets/gadget-kit/get-gadget.md', 'docs/references/widgets/gadget-kit/tests/get-gadget.md',
            'docs/references/widgets/gadget-kit/index.md', 'docs/references/widgets/overview.md', 'docs/other/notes.md'
        }
        $result = Test-ReferencePages -PassThru -OutputFolder $script:outputFolder
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Facts['Pages'] | Should -Be 4
    }

    It 'names a page with no source, and a page two sources share' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates {
            'widgets/Gadget.Kit/Get-Gadget.ps1', 'widgets/Gadget.Kit/Get-Gadget.cs', 'docs/references/widgets/gadget-kit/stale.md'
        }
        $result = Test-ReferencePages -PassThru -OutputFolder $script:outputFolder
        $result.IssueCount | Should -Be 2
        $result.Issues | Should -Contain ('docs/references/widgets/gadget-kit/get-gadget.md is the page of 2 sources (widgets/Gadget.Kit/Get-Gadget.ps1, ' +
            'widgets/Gadget.Kit/Get-Gadget.cs); rename one so each page maps back to exactly one source')
        $result.Issues | Should -Contain ('docs/references/widgets/gadget-kit/stale.md maps back to no source file; move it to its source''s ' +
            'derived page, delete it, or list it under articles in comment-pages.yml')
    }

    It 'names an article that is also a derived page' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates { 'widgets/Overview/x.ps1' }
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'comment-pages' } {
            [Catzc.Base.CodeMeta.CommentPagesConfig]::new([ordered]@{
                    pages    = @([ordered]@{ source = 'widgets/*'; docs = 'docs/references/widgets' })
                    articles = @('docs/references/widgets/overview/index.md')
                })
        }
        (Test-ReferencePages -PassThru -OutputFolder $script:outputFolder).Issues |
            Should -Contain 'docs/references/widgets/overview/index.md is listed under articles but is the derived page of widgets/Overview; drop it from articles'
    }
}

Describe 'Test-ReferencePages — the real tree' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
    It 'finds every reference page mapping back to exactly one source, and no two sources sharing a page' {
        $result = Test-ReferencePages -PassThru -OutputFolder (Join-Path $TestDrive 'report')
        $result.Facts['Pages'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
