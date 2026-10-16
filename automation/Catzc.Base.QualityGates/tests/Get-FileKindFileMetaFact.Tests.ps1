<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/tests/Get-FileKindFileMetaFact.Tests.ps1
    folder: tests
    name: get-file-kind-file-meta-fact-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#3
---
#>

Describe 'Get-FileKindFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3', 'ADR-PRIN-CONFIG#1' {
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
            param([string] $Path, [string[]] $Keys = @('kind', 'subkind'))
            $kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-kind' = @{ keys = $Keys } } }).kinds[0]
            $state = Get-MarkdownMetaState -Text "# $Path`n"
            InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $kind; Path = $Path } {
                param($State, $Kind, $Path)
                Get-FileKindFileMetaFact -State $State -Path $Path -Kind $Kind
            }
        }
    }

    It 'names the kind whose globs match the path, under the kind''s first key' -ForEach @(
        @{ Path = 'docs/widgets/part.md'; Expected = 'widget' }
        @{ Path = 'docs/deep/gadget.md'; Expected = 'gadget' }
        @{ Path = 'tools/notes.md'; Expected = 'gadget' }
    ) {
        $fact = Get-Fact $Path
        @($fact.Keys) | Should -Be @('kind', 'subkind')
        $fact['kind'] | Should -BeExactly $Expected
        $fact['subkind'] | Should -BeExactly ''
    }

    It 'names the subkind under the kind''s second key' {
        $fact = Get-Fact 'docs/deep/cog.md'
        $fact['kind'] | Should -BeExactly 'gadget'
        $fact['subkind'] | Should -BeExactly 'cog'
    }

    It 'takes the first kind that matches, in the order declared' {
        (Get-Fact 'docs/widgets/gadget.md')['kind'] | Should -BeExactly 'widget'
    }

    It 'names a file no kind matches other' {
        (Get-Fact 'elsewhere/notes.md')['kind'] | Should -BeExactly 'other'
    }

    It 'writes only the kind when the registry entry lists one key' {
        $fact = Get-Fact 'docs/deep/cog.md' @('kind')
        @($fact.Keys) | Should -Be @('kind')
        $fact['kind'] | Should -BeExactly 'gadget'
    }
}
