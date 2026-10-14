Describe 'Get-MarkdownTitleScope' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#6' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
    }

    BeforeEach {
        # git is the one boundary: ls-files lists what is tracked, check-attr says what .gitattributes marks.
        Mock Get-GitTrackedPath {
            'docs/widget.md', 'docs/widget.yml', '.claude/CLAUDE.md', 'automation/.vendor/Gadget/README.md',
            'automation/Widget/tests/assets/fixture.md', 'docs/generated-widget.md', '.github/README.md',
            'contracts/widget/0.0.0/Gadget/.github/README.md'
        } -ModuleName Catzc.Base.QualityGates
        # The declared classes, as .gitattributes would report them (unspecified attributes are left out).
        Mock Get-GitAttributeValue {
            @{
                'automation/.vendor/Gadget/README.md'             = @{ 'linguist-vendored' = 'set' }
                'automation/Widget/tests/assets/fixture.md'       = @{ 'catzc-fixture' = 'set' }
                'docs/generated-widget.md'                        = @{ 'linguist-generated' = 'set' }
                '.github/README.md'                               = @{ 'catzc-path-title' = 'unset' }
                'contracts/widget/0.0.0/Gadget/.github/README.md' = @{ 'catzc-contract' = 'set' }
            }
        } -ModuleName Catzc.Base.QualityGates
    }

    It 'keeps tracked Markdown and drops the vendored, generated, fixture, contract, own-title, and non-Markdown files' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownTitleScope -RepositoryRoot $Root
        }
        $scope | Should -Be @('docs/widget.md', '.claude/CLAUDE.md')
    }

    It 'asks .gitattributes about the exempt classes and the own-title class, for the tracked Markdown only' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownTitleScope -RepositoryRoot $Root
        } | Out-Null
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            'catzc-fixture' -in $Attribute -and 'catzc-contract' -in $Attribute -and 'docs/widget.yml' -notin $Path
        }
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            'catzc-path-title' -in $Attribute -and 'docs/widget.yml' -notin $Path
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
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
