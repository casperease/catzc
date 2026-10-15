---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Get-GlobSetFile.ps1.md
    kind: comment-page
    body_sha: "9314a484eff5"
    adrs:
      - ADR-FLOW-CD-GLOBS#4
      - ADR-FLOW-CD-GLOBS#5
    links: []
---

# automation/Catzc.Base.Globs/Get-GlobSetFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Intersects the matching universe (`git ls-files`,
[ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)) with the named globset's
membership
(include minus exclude), ordinally sorted — the exact file list the durable SHA is computed over
([ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)). A member may be missing on
disk (an unstaged deletion); it is still a member here.
```
