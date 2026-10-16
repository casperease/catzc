---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Links.Untracked.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "186a878d371c"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-LINK#2
---

# automation/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-Links — untracked link targets' -Tag 'L0', 'logic',...`, written with `#`.

```text
A markdown link must resolve on GitHub, which has only what git tracks
([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)). A fixture repository in $TestDrive stands
in for the loaded repository; its tracked set is mocked (neutral widget/gadget names,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
