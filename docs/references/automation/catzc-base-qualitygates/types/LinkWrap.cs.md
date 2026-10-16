---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/LinkWrap.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: cde1f722ed85
    adrs:
      - ADR-REPO-LINK#8
---

# automation/Catzc.Base.QualityGates/types/LinkWrap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.QualityGates;`, written with `//`.

```text
How the link aligner treats a comment line that outgrows its line limit once a citation becomes a code link
([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)): Break continues the comment on a new line before the
link (never inside it), with the same
comment prefix and indent; Off leaves the line long and reports it. Configured in links.yml.
```
