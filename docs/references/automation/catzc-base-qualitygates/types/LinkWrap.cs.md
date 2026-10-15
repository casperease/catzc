---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/LinkWrap.cs.md
    kind: comment-page
    body_sha: "575c89666bba"
    adrs:
      - ADR-REPO-LINK#8
    links: []
---

# automation/Catzc.Base.QualityGates/types/LinkWrap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.QualityGates;`.

```text
How the link aligner treats a comment line that outgrows its line limit once a citation becomes a code link
([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)): Break continues the comment on a new line before the
link (never inside it), with the same
comment prefix and indent; Off leaves the line long and reports it. Configured in links.yml.
```
