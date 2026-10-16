<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-MarkdownScope.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    adrs:
      - ADR-REPO-FILEMETA#5
      - ADR-REPO-FORMAT#6
---
#>

Describe 'Get-MarkdownScope' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#6', 'ADR-REPO-FILEMETA#5' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
    }

    BeforeEach {
        # git is the one boundary: ls-files lists what is tracked, check-attr says what .gitattributes marks.
        Mock Get-GitTrackedPath {
            'docs/widget.md', 'docs/widget.yml', 'docs/own-meta.md', 'automation/.vendor/Gadget/README.md',
            'automation/Widget/tests/assets/fixture.md', 'docs/generated-widget.md',
            'contracts/widget/0.0.0/Gadget/.github/README.md'
        } -ModuleName Catzc.Base.QualityGates
        # The declared classes, as .gitattributes would report them (unspecified attributes are left out).
        Mock Get-GitAttributeValue {
            @{
                'automation/.vendor/Gadget/README.md'             = @{ 'linguist-vendored' = 'set' }
                'automation/Widget/tests/assets/fixture.md'       = @{ 'catzc-fixture' = 'set' }
                'docs/generated-widget.md'                        = @{ 'linguist-generated' = 'set' }
                'docs/own-meta.md'                                = @{ 'catzc-meta' = 'unset' }
                'contracts/widget/0.0.0/Gadget/.github/README.md' = @{ 'catzc-contract' = 'set' }
            }
        } -ModuleName Catzc.Base.QualityGates
    }

    It 'keeps tracked Markdown and drops the vendored, generated, fixture, contract and non-Markdown files' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownScope -RepositoryRoot $Root
        }
        $scope | Should -Be @('docs/widget.md', 'docs/own-meta.md')
    }

    It 'drops a file whose opt-out attribute is unset, and only when an opt-out is named' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownScope -RepositoryRoot $Root -OptOut catzc-meta
        }
        $scope | Should -Be @('docs/widget.md')
    }

    It 'asks .gitattributes about the exempt classes for the tracked Markdown only, and about the opt-out only when one is named' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownScope -RepositoryRoot $Root
        } | Out-Null
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            'catzc-fixture' -in $Attribute -and 'catzc-contract' -in $Attribute -and 'docs/widget.yml' -notin $Path
        }
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownScope -RepositoryRoot $Root -OptOut catzc-meta
        } | Out-Null
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            'catzc-meta' -in $Attribute -and 'docs/widget.yml' -notin $Path
        }
    }

    It 'narrows to a -Path inside the repository, repository-relative' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Item = (Join-Path $script:widgetRoot 'docs') } {
            param($Root, $Item)
            Get-MarkdownScope -RepositoryRoot $Root -Path $Item
        } | Out-Null
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Path -eq 'docs' }
    }

    It 'refuses a -Path outside the repository' {
        {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Item = $TestDrive } {
                param($Root, $Item)
                Get-MarkdownScope -RepositoryRoot $Root -Path $Item
            }
        } | Should -Throw '*outside the repository*'
    }

    It 'returns nothing, without asking git about attributes, when no Markdown is tracked' {
        Mock Get-GitTrackedPath { 'docs/widget.yml' } -ModuleName Catzc.Base.QualityGates
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownScope -RepositoryRoot $Root -OptOut catzc-meta
        }
        @($scope).Count | Should -Be 0
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
