---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/GitHubAnchor.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "473ce1b81231"
    adrs:
      - ADR-REPO-LINK#2
---

# automation/Catzc.Base.Docs/tests/types/GitHubAnchor.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GitHubAnchor' -Tag 'L0', 'logic' {`, written with `#`.

```text
The GitHub slug and anchor set a markdown link's #fragment must name
([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)). The slug cases are the
shapes the repository's headings take: rule headings, responsibility headings with an em dash, code spans, and duplicates.
```
