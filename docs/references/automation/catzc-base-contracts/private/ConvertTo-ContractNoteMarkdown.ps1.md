---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/ConvertTo-ContractNoteMarkdown.ps1.md
    kind: comment-page
    body_sha: "43721800bfa4"
    adrs:
      - ADR-REPO-LINK#2
      - ADR-REPO-LINK#3
---

# automation/Catzc.Base.Contracts/private/ConvertTo-ContractNoteMarkdown.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A note is written as a comment (Get-ContractAssetNote), where an ADR citation is a repository-rooted code link
([ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)). On the generated page it is markdown,
so each part is rewritten to its markdown form:
- a link whose destination starts with '/' becomes relative to the page's folder, its #fragment kept
  ([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2));
- a bare https:// or http:// address becomes an autolink, <address>, so it renders as a link and is not a bare URL;
- a '<' that opens no autolink is escaped, so it is never read as inline HTML.
Code spans keep their text; every other link and autolink is left as written.
```
