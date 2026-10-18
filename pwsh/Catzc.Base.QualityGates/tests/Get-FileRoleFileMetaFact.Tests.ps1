Describe 'Get-FileRoleFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3', 'ADR-PRIN-CONFIG#1' {
    BeforeAll {
        $script:registry = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{
                    widget = [ordered]@{ definition = 'A widget file.'; files = @('docs/widgets/**') }
                    gadget = [ordered]@{
                        definition = 'A gadget file.'
                        subkinds   = [ordered]@{ cog = [ordered]@{ definition = 'A cog of a gadget.'; files = @('docs/**/cog.md') } }
                        files      = @('docs/**/gadget.md', 'tools/*.md')
                    }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'file-kinds' } { $script:registry }

        function script:Get-Fact {
            param([string] $Path, [string[]] $Keys = @('role', 'subkind'))
            $kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-role' = @{ keys = $Keys } } }).kinds[0]
            $state = Get-MarkdownMetaState -Text "# $Path`n"
            InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $kind; Path = $Path } {
                param($State, $Kind, $Path)
                Get-FileRoleFileMetaFact -State $State -Path $Path -Kind $Kind
            }
        }
    }

    It 'names the role of the kind whose globs match the path, under the first key' -ForEach @(
        @{ Path = 'docs/widgets/part.md'; Expected = 'widget' }
        @{ Path = 'docs/deep/gadget.md'; Expected = 'gadget' }
        @{ Path = 'tools/notes.md'; Expected = 'gadget' }
    ) {
        $fact = Get-Fact $Path
        @($fact.Keys) | Should -Be @('role', 'subkind')
        $fact['role'] | Should -BeExactly $Expected
        $fact['subkind'] | Should -BeExactly ''
    }

    It 'names the subkind under the second key' {
        $fact = Get-Fact 'docs/deep/cog.md'
        $fact['role'] | Should -BeExactly 'gadget'
        $fact['subkind'] | Should -BeExactly 'cog'
    }

    It 'takes the first kind that matches, in the order declared' {
        (Get-Fact 'docs/widgets/gadget.md')['role'] | Should -BeExactly 'widget'
    }

    It 'names a file no kind matches other' {
        (Get-Fact 'elsewhere/notes.md')['role'] | Should -BeExactly 'other'
    }

    It 'writes only the role when the registry entry lists one key' {
        $fact = Get-Fact 'docs/deep/cog.md' @('role')
        @($fact.Keys) | Should -Be @('role')
        $fact['role'] | Should -BeExactly 'gadget'
    }
}
