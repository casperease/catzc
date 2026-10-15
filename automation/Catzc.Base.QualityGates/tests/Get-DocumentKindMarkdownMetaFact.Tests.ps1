Describe 'Get-DocumentKindMarkdownMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-MDMETA#3', 'ADR-PRIN-CONFIG#1' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.MarkdownMetaConfig]::new(@{
                kinds = [ordered]@{
                    'document-kind' = @{
                        keys     = @('kind')
                        settings = @{
                            classes = @(
                                @{ class = 'widget'; files = @('docs/widgets/**') }
                                @{ class = 'gadget'; files = @('docs/**/gadget.md', 'tools/*.md') }
                            )
                        }
                    }
                }
            }).kinds[0]

        function script:Get-Class {
            param([string] $Path, $Kind = $script:kind)
            $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("# $Path`n")
            $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ Document = $document; Kind = $Kind; Path = $Path } {
                param($Document, $Kind, $Path)
                Get-DocumentKindMarkdownMetaFact -Document $Document -Path $Path -Kind $Kind
            }
            $fact['kind']
        }
    }

    It 'names the class whose globs match the path' -ForEach @(
        @{ Path = 'docs/widgets/part.md'; Expected = 'widget' }
        @{ Path = 'docs/deep/gadget.md'; Expected = 'gadget' }
        @{ Path = 'tools/notes.md'; Expected = 'gadget' }
    ) {
        Get-Class -Path $Path | Should -BeExactly $Expected
    }

    It 'takes the first class that matches, in the order declared' {
        Get-Class -Path 'docs/widgets/gadget.md' | Should -BeExactly 'widget'
    }

    It 'names a file no class matches other' {
        Get-Class -Path 'elsewhere/notes.md' | Should -BeExactly 'other'
    }

    It 'names every file other when the kind declares no classes' {
        $bare = [Catzc.Base.QualityGates.MarkdownMetaConfig]::new(@{ kinds = [ordered]@{ 'document-kind' = @{ keys = @('kind') } } }).kinds[0]
        Get-Class -Path 'docs/widgets/part.md' -Kind $bare | Should -BeExactly 'other'
    }

    It 'rejects a class entry that lacks its files' {
        $bad = [Catzc.Base.QualityGates.MarkdownMetaConfig]::new(@{
                kinds = [ordered]@{ 'document-kind' = @{ keys = @('kind'); settings = @{ classes = @(@{ class = 'widget' }) } } }
            }).kinds[0]
        { Get-Class -Path 'docs/a.md' -Kind $bad } | Should -Throw "*entries need 'class' and 'files'*"
    }
}
