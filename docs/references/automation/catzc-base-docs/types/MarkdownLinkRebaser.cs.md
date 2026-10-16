---
catzc:
  immutable:
    with_body_sha: "78ccf8b2ed35"
    path: docs/references/automation/catzc-base-docs/types/MarkdownLinkRebaser.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: markdown-link-rebaser-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-README#6
---

# automation/Catzc.Base.Docs/types/MarkdownLinkRebaser.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Rebases the relative links of a markdown article for a copy of it in another folder: every relative link target is
resolved at the article's own folder and rewritten relative to the copy's folder, so each link works where the copy is
opened ([ADR-REPO-README#6](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme6)). Left as written: fenced
code blocks and inline code spans, URLs (a scheme), in-file #anchors, repository-rooted /targets, and a target that
climbs above the repository root. The link grammar is the one the Test-Links quality gate reads (MarkdownLinkScanner).
Pure: paths are repository-relative and '/'-separated, so the result does not depend on the OS or the disk.
```

## comment:2

Above `public static string Rebase(string text, string sourceRepoPath, string...`, written with `//`.

```text
The article's text with every relative link rebased from sourceRepoPath's folder to folderRepoPath.
sourceRepoPath: the article, e.g. docs/references/contracts.md. folderRepoPath: the copy's folder, e.g. contracts
('' is the repository root).
```
