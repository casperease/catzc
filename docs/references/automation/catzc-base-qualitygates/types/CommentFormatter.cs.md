---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/CommentFormatter.cs.md
    kind: reference
    body_sha: ea96e4274923
    adrs:
      - ADR-AUTO-IDEM#1
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-COMMENTS#1
      - ADR-REPO-COMMENTS#5
---

# automation/Catzc.Base.QualityGates/types/CommentFormatter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The residue formatter behind Format-Comments: pure over a file's text, built only on CommentEngine's public
surface, so the one-liner shape is checked and repaired in one place. A residue is one insight line, then one
line with the comment's ADR citations and the docs link `[comment:N](/<page>#commentN)`
([ADR-REPO-COMMENTS#1](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments1)); the insight says what
the code does not, within the file's line limit, with no link in it and without one of comments.yml's obvious
phrases ([ADR-REPO-COMMENTS#5](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments5),
[ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
  Format   every residue of a file against its page: a missing insight is cut from the comment's own section, a
           link or citation in the insight goes to the link line, an overlong insight is cut at a word; an obvious
           insight, prose on the link line, a residue without a section and a comment that still outgrows a line
           are reported for a person (or Export-Comments). The file's own line endings are kept, line by line.
A second run over a formatted file changes nothing ([ADR-AUTO-IDEM#1](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem1)).
```
