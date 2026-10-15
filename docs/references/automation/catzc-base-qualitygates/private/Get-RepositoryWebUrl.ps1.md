---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-RepositoryWebUrl.ps1.md
    kind: comment-page
    body_sha: "83818b61713d"
    adrs:
      - ADR-REPO-LINK#7
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-RepositoryWebUrl.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the origin remote from <root>/.git/config — no git process — and normalizes an https or ssh GitHub
remote to its web URL. Test-Links uses it to recognise an absolute URL into this repository, which belongs
only under .github/ ([ADR-REPO-LINK#7](/docs/adr/repository/markdown-links.md#rule-adr-repo-link7)). A root with no
.git/config (a test fixture, an exported build) or a
non-GitHub remote yields $null, and that check is skipped.
```
