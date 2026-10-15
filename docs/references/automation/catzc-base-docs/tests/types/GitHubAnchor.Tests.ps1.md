---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/GitHubAnchor.Tests.ps1.md
    kind: test-asset
    body_sha: "2294eb40b7ea"
    adrs:
      - ADR-REPO-LINK#2
---

# automation/Catzc.Base.Docs/tests/types/GitHubAnchor.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'GitHubAnchor' -Tag 'L0', 'logic' {`.

```text
The GitHub slug and anchor set a markdown link's #fragment must name
([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)). The slug cases are the
shapes the repository's headings take: rule headings, responsibility headings with an em dash, code spans, and duplicates.
```
