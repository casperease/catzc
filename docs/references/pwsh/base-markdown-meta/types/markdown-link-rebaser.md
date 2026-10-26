# pwsh/Base.MarkdownMeta/types/MarkdownLinkRebaser.cs

Rebases the relative links of a markdown article for a copy of it in another folder. Every relative link target is resolved at the article's
own folder and rewritten relative to the copy's folder, so each link works where the copy is opened
([ADR-REPO-README-WORKINGLINKS](../../../../drs/repository/generated-readmes.md#rule-adr-repo-readme-workinglinks)).

## What it leaves alone

Fenced code blocks and inline code spans, URLs (a target with a scheme), in-file `#anchors`, repository-rooted `/targets`, and a target that
climbs above the repository root stay as written. The link grammar is the one the `Test-Links` quality gate reads (`MarkdownLinkScanner`).

## Rebase

`Rebase(text, sourceRepoPath, folderRepoPath)` returns the article's text with every relative link rebased from `sourceRepoPath`'s folder to
`folderRepoPath`. `sourceRepoPath` is the article, for example `docs/references/contracts.md`. `folderRepoPath` is the copy's folder, for
example `contracts`; an empty string is the repository root.

## Why it is shaped so

The type is pure. Paths are repository-relative and `/`-separated, so the result does not depend on the OS or the disk.
