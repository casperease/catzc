Describe 'Get-FileKindFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3', 'ADR-PRIN-CONFIG#1' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{
                    'file-kind' = @{
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
            $state = Get-MarkdownMetaState -Text "# $Path`n"
            $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $Kind; Path = $Path } {
                param($State, $Kind, $Path)
                Get-FileKindFileMetaFact -State $State -Path $Path -Kind $Kind
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
        $bare = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-kind' = @{ keys = @('kind') } } }).kinds[0]
        Get-Class -Path 'docs/widgets/part.md' -Kind $bare | Should -BeExactly 'other'
    }

    It 'rejects a class entry that lacks its files' {
        $bad = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{ 'file-kind' = @{ keys = @('kind'); settings = @{ classes = @(@{ class = 'widget' }) } } }
            }).kinds[0]
        { Get-Class -Path 'docs/a.md' -Kind $bad } | Should -Throw "*entries need 'class' and 'files'*"
    }
}
