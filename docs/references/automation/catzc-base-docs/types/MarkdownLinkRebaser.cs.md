---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/MarkdownLinkRebaser.cs.md
    kind: comment-page
    body_sha: "9609576333ae"
    adrs:
      - ADR-REPO-README#6
    links: []
---

# automation/Catzc.Base.Docs/types/MarkdownLinkRebaser.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Rebases the relative links of a markdown article for a copy of it in another folder: every relative link target is
resolved at the article's own folder and rewritten relative to the copy's folder, so each link works where the copy is
opened ([ADR-REPO-README#6](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme6)). Left as written: fenced
code blocks and inline code spans, URLs (a scheme), in-file #anchors, repository-rooted /targets, and a target that
climbs above the repository root. The link grammar is the one the Test-Links quality gate reads (MarkdownLinkScanner).
Pure: paths are repository-relative and '/'-separated, so the result does not depend on the OS or the disk.
```

## comment:2

Above `public static string Rebase(string text, string sourceRepoPath, string...`.

```text
The article's text with every relative link rebased from sourceRepoPath's folder to folderRepoPath.
sourceRepoPath: the article, e.g. docs/references/contracts.md. folderRepoPath: the copy's folder, e.g. contracts
('' is the repository root).
```
