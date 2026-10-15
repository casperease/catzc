<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-FilePathFileMetaFact.Tests.ps1
    kind: test
---
#>

Describe 'Get-FilePathFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-path' = @{ keys = @('path') } } }).kinds[0]
    }

    It 'returns the repository-relative path under the kind''s key' {
        $state = Get-MarkdownMetaState -Text "# Widget`n`nbody`n"
        $fact = InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
            param($State, $Kind)
            Get-FilePathFileMetaFact -State $State -Path 'docs/widget/gadget.md' -Kind $Kind
        }
        $fact.Keys | Should -Be @('path')
        $fact['path'] | Should -BeExactly 'docs/widget/gadget.md'
    }

    It 'follows the file when it moves' {
        $state = Get-MarkdownMetaState -Text "# Widget`n"
        $paths = foreach ($path in 'docs/widget.md', 'docs/gadget/widget.md') {
            (InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind; Path = $path } {
                param($State, $Kind, $Path)
                Get-FilePathFileMetaFact -State $State -Path $Path -Kind $Kind
            })['path']
        }
        $paths | Should -Be @('docs/widget.md', 'docs/gadget/widget.md')
    }
}
