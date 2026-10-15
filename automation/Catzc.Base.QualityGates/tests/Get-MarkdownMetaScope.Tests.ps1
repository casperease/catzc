Describe 'Get-MarkdownMetaScope' -Tag 'L0', 'logic', 'ADR-REPO-MDMETA#5' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
    }

    BeforeEach {
        Mock Get-GitTrackedPath {
            'docs/widget.md', 'docs/widget.yml', 'automation/.vendor/Gadget/README.md', 'docs/generated-widget.md', 'docs/own-meta.md',
            '.github/README.md'
        } -ModuleName Catzc.Base.QualityGates
        Mock Get-GitAttributeValue {
            @{
                'automation/.vendor/Gadget/README.md' = @{ 'linguist-vendored' = 'set' }
                'docs/generated-widget.md'            = @{ 'linguist-generated' = 'set' }
                'docs/own-meta.md'                    = @{ 'catzc-meta' = 'unset' }
                '.github/README.md'                   = @{ 'catzc-path-title' = 'unset' }
            }
        } -ModuleName Catzc.Base.QualityGates
    }

    It 'keeps tracked Markdown and drops the vendored, generated, own-meta and non-Markdown files' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownMetaScope -RepositoryRoot $Root
        }
        $scope | Should -Be @('docs/widget.md', '.github/README.md')
    }

    It 'keeps a file that opts out of the title only, since the meta block has its own attribute' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownMetaScope -RepositoryRoot $Root
        }
        $scope | Should -Contain '.github/README.md'
    }

    It 'asks .gitattributes for the meta opt-out of the tracked Markdown only' {
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            Get-MarkdownMetaScope -RepositoryRoot $Root
        } | Out-Null
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            'catzc-meta' -in $Attribute -and 'docs/widget.yml' -notin $Path
        }
    }

    It 'returns an empty list when nothing tracked is Markdown' {
        Mock Get-GitTrackedPath { 'docs/widget.yml' } -ModuleName Catzc.Base.QualityGates
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot } {
            param($Root)
            , (Get-MarkdownMetaScope -RepositoryRoot $Root)
        }
        $scope.Count | Should -Be 0
    }

    It 'rejects a path outside the repository' {
        $outside = Join-Path $TestDrive 'elsewhere'
        [System.IO.Directory]::CreateDirectory($outside) | Out-Null
        { InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Outside = $outside } {
                param($Root, $Outside)
                Get-MarkdownMetaScope -RepositoryRoot $Root -Path $Outside
            } } | Should -Throw '*lies outside the repository*'
    }
}
