---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0e1dbe878436"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-LINK#{2,3}
---

# automation/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ConvertTo-ContractNoteMarkdown' -Tag 'L0', 'logic' {`, written with `#`.

```text
A note is written as a comment, where a citation is a repository-rooted code link
([ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)); in a list item of a generated page it
is markdown, so a rooted link turns relative to the page
([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)). Fixtures are neutral
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
