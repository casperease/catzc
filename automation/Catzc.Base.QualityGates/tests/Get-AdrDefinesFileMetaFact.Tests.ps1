<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-AdrDefinesFileMetaFact.Tests.ps1
    kind: pester-test
---
#>

Describe 'Get-AdrDefinesFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'adr-defines' = @{ keys = @('defines') } } }).kinds[0]

        function script:Get-Defines {
            param([string] $Body)
            $state = Get-MarkdownMetaState -Text $Body
            InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Kind = $script:kind } {
                param($State, $Kind)
                Get-AdrDefinesFileMetaFact -State $State -Path 'docs/adr/widget.md' -Kind $Kind
            }
        }
    }

    It 'lists the rules the file defines under the kind''s key' {
        $fact = Get-Defines "# ADR: Widget`n`n## Rules: ADR-WIDGET`n`n### Rule ADR-WIDGET:1`n`n### Rule ADR-WIDGET:2`n"
        @($fact.Keys) | Should -Be @('defines')
        @($fact['defines']) | Should -Be @('ADR-WIDGET#1', 'ADR-WIDGET#2')
    }

    It 'lists no rule for a file that defines none, however many it cites' {
        $fact = Get-Defines "# ADR: Index`n`nSee ADR-GADGET#4.`n"
        @($fact['defines']).Count | Should -Be 0
    }

    It 'does not read a heading from the front matter' {
        $fact = Get-Defines "---`ncatzc:`n  derived:`n    defines:`n      - ADR-WIDGET#9`n---`nbody`n"
        @($fact['defines']).Count | Should -Be 0
    }
}
