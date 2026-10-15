---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Resolve-AdrLinkTarget.Tests.ps1.md
    kind: test-asset
    body_sha: f3a95d80503d
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-LINK#2
---

# automation/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Resolve-AdrLinkTarget' -Tag 'L0', 'logic', 'ADR-REPO-LINK#2' {`.

```text
Resolve-AdrLinkTarget — a markdown link in a file under docs/adr/, resolved relative to its file
([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)) to its path under docs/adr/. Pure path logic: the
fixture root need not exist. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
