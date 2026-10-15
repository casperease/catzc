<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-RepointedMarkdownText.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-REPO-FORMAT#7
---
#>

Describe 'Get-RepointedMarkdownText' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#7' {
    BeforeAll {
        function script:Get-Repointed {
            param([string] $Text, [string] $RelativePath = 'docs/adr/widget/widget-rules.md')
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text; RelativePath = $RelativePath } {
                param($Text, $RelativePath)
                $rename = @{ 'docs/adr/gadget/gadget-rules.md#validation-assert-gadget' = 'validation'; 'docs/adr/widget/widget-rules.md#old' = 'new' }
                Get-RepointedMarkdownText -RelativePath $RelativePath -Text $Text -Rename $rename
            }
        }
    }

    It 're-points a relative link to a renamed anchor, keeping the target as written' {
        Get-Repointed 'See [it](../gadget/gadget-rules.md#validation-assert-gadget).' | Should -Be 'See [it](../gadget/gadget-rules.md#validation).'
    }

    It 're-points a link to the file''s own heading' {
        Get-Repointed 'See [it](#old).' | Should -Be 'See [it](#new).'
    }

    It 'resolves ./ and a link from another folder depth' {
        Get-Repointed 'See [it](./gadget/gadget-rules.md#validation-assert-gadget).' -RelativePath 'docs/adr/index.md' |
            Should -Be 'See [it](./gadget/gadget-rules.md#validation).'
    }

    It 'leaves a link to another anchor or another file alone' {
        $text = 'See [a](../gadget/gadget-rules.md#summary) and [b](../other/gadget-rules.md#validation-assert-gadget).'
        Get-Repointed $text | Should -BeExactly $text
    }
}
