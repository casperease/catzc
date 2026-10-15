<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-LINK#2
      - ADR-REPO-LINK#3
      - ADR-REPO-LINK#7
---
#>

# A note is written as a comment, where a citation is a repository-rooted code link; in a list item of a generated...
# [comment:1](/docs/references/automation/catzc-base-contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1.md#comment1)
Describe 'ConvertTo-ContractNoteMarkdown' -Tag 'L0', 'logic' {
    BeforeAll {
        function ConvertTo-Markdown {
            param([string] $Note, [string] $PageFolder = 'docs/references/widgets')
            InModuleScope Catzc.Base.Contracts -Parameters @{ Note = $Note; PageFolder = $PageFolder } {
                param($Note, $PageFolder)
                ConvertTo-ContractNoteMarkdown -Note $Note -PageFolder $PageFolder
            }
        }
    }

    It 'makes a repository-rooted link relative to the page, keeping its fragment' -Tag 'ADR-REPO-LINK#2' {
        ConvertTo-Markdown 'Pinned by [ADR-TST-WIDGET#2](/docs/adr/repository/widget-thing.md#rule-adr-tst-widget2).' |
            Should -BeExactly 'Pinned by [ADR-TST-WIDGET#2](../../adr/repository/widget-thing.md#rule-adr-tst-widget2).'
        ConvertTo-Markdown 'See [gadget](/docs/references/widgets/gadget.md).' | Should -BeExactly 'See [gadget](gadget.md).'
    }

    It 'leaves a relative link, an autolink, and a code span as written' -Tag 'ADR-REPO-LINK#2' {
        $note = 'See [gadget](gadget.md), <https://example.com/widget>, and `[widget](/docs/widget.md)`.'
        ConvertTo-Markdown $note | Should -BeExactly $note
    }

    It 'turns a bare address into an autolink, leaving trailing punctuation outside' -Tag 'ADR-REPO-LINK#7' {
        ConvertTo-Markdown 'Spec: https://example.com/widget/gadget.' | Should -BeExactly 'Spec: <https://example.com/widget/gadget>.'
    }

    It 'escapes a < that opens no autolink, and leaves a pipe as written' {
        ConvertTo-Markdown 'The `widget|gadget` key, per <id>.' | Should -BeExactly 'The `widget|gadget` key, per \<id>.'
    }
}
