Describe 'Get-MarkdownTitleScope' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#6' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
    }

    BeforeEach {
        # git is the one boundary: ls-files lists what is tracked, check-attr says what .gitattributes marks.
        Mock Get-GitTrackedPath {
            'docs/widget.md', 'docs/widget.yml', '.claude/CLAUDE.md', 'automation/.vendor/Gadget/README.md',
            'automation/Widget/tests/assets/fixture.md', 'docs/generated-widget.md'
        } -ModuleName Catzc.Base.QualityGates
        Mock Invoke-Executable {
            [pscustomobject]@{
                ExitCode = 0
                Output   = @(
                    'docs/widget.md: linguist-vendored: unspecified'
                    'docs/widget.md: linguist-generated: unspecified'
                    '.claude/CLAUDE.md: linguist-vendored: unspecified'
                    '.claude/CLAUDE.md: linguist-generated: unspecified'
                    'automation/.vendor/Gadget/README.md: linguist-vendored: set'
                    'automation/.vendor/Gadget/README.md: linguist-generated: unspecified'
                    'docs/generated-widget.md: linguist-vendored: unspecified'
                    'docs/generated-widget.md: linguist-generated: set'
                ) -join "`n"
            }
        } -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -like '*check-attr*' }
    }

    It 'keeps tracked Markdown and drops vendored, generated, fixture, and non-Markdown files' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownTitleScope -RepositoryRoot $Root
        }
        $scope | Should -Be @('docs/widget.md', '.claude/CLAUDE.md')
    }

    It 'asks .gitattributes only about the tracked Markdown, never the fixtures' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownTitleScope -RepositoryRoot $Root
        } | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -like '*check-attr*' -and $Command -notlike '*tests/assets*' -and $Command -notlike '*widget.yml*'
        }
    }

    It 'narrows to a -Path inside the repository, repository-relative' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Item = (Join-Path $script:widgetRoot 'docs') } {
            param($Root, $Item)
            Get-MarkdownTitleScope -RepositoryRoot $Root -Path $Item
        } | Out-Null
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Path -eq 'docs' }
    }

    It 'refuses a -Path outside the repository' {
        {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Item = $TestDrive } {
                param($Root, $Item)
                Get-MarkdownTitleScope -RepositoryRoot $Root -Path $Item
            }
        } | Should -Throw '*outside the repository*'
    }

    It 'returns nothing, without asking git about attributes, when no Markdown is tracked' {
        Mock Get-GitTrackedPath { 'docs/widget.yml' } -ModuleName Catzc.Base.QualityGates
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownTitleScope -RepositoryRoot $Root
        }
        @($scope).Count | Should -Be 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
