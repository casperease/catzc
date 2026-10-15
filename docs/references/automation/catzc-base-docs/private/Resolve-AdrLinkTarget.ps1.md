---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Resolve-AdrLinkTarget.ps1.md
    kind: comment-page
    body_sha: c3497bc3dff1
    adrs:
      - ADR-REPO-LINK#2
---

# automation/Catzc.Base.Docs/private/Resolve-AdrLinkTarget.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A markdown link is relative to its own file ([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)). This
drops the target's #fragment, resolves the rest against the linking file's folder, and returns the result relative to docs/adr/
('/'-separated). It returns nothing for a link that names no file under docs/adr/: an in-page anchor, an absolute URL, a
repository-rooted path, or a relative path that leaves docs/adr/.

Private helper for the citation-graph and DORA-coverage checks of Test-AdrRegistry; not exported.
```
