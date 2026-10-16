<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-LinksFileMetaFact.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Get-LinksFileMetaFact.ps1
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

Describe 'Get-LinksFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ links = @{} } }).kinds[0]

        function script:Get-Links {
            param([string] $Body, [string] $Path = 'docs/widget/part.md')
            $state = Get-MarkdownMetaState -Text $Body
            InModuleScope Catzc.Base.QualityGates -Parameters @{ State = $state; Path = $Path; Kind = $script:kind } {
                param($State, $Path, $Kind)
                Get-LinksFileMetaFact -State $State -Path $Path -Kind $Kind
            }
        }
    }

    It 'lists each link once under the kind''s key, sorted and in one spelling' {
        $fact = Get-Links "[b](../gadget/spec.md#top) [a](/docs/gadget/spec.md#top) [c](https://example.com/doc)`n"
        @($fact.Keys) | Should -Be @('links')
        @($fact['links']) | Should -Be @('docs/gadget/spec.md#top', 'https://example.com/doc')
    }

    It 'leaves a link that stays inside the file out' {
        @((Get-Links "[a](#top) [b](part.md#top)`n")['links']).Count | Should -Be 0
    }

    It 'does not read a link from the front matter' {
        $fact = Get-Links "---`ncatzc:`n  derived:`n    links:`n      - docs/gadget/spec.md`n---`nbody`n"
        @($fact['links']).Count | Should -Be 0
    }
}
