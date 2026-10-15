---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-ReadmeContent.ps1.md
    kind: comment-page
    body_sha: "8194c6fcd060"
    adrs:
      - ADR-REPO-README#6
    links: []
---

# automation/Catzc.Base.Docs/private/Get-ReadmeContent.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one composer behind Build-Readme (the writer) and Test-GeneratedReadmes (the quality gate). The source's relative links
are rebased from the source's folder to the README's (MarkdownLinkRebaser), so every link works where the README is
opened; a line under the title links back to the source as the one place to edit
([ADR-REPO-README#6](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme6)). The line goes after the
source's '# ' title when it opens with one, else at the top. The copy opens with its own meta block,
`kind: generated-from-source`, above both.
```
