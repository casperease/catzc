---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/configs/gitignore.yml.md
    kind: comment-page
    body_sha: "812c84827eb7"
---

# automation/Catzc.Base.Git/configs/gitignore.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `sections:`.

```text
Gitignore registry — the single source of truth for the repository-root .gitignore. New-GitIgnore renders
these sections (in order) into the sectioned, commented .gitignore, which is itself a managed, COMMITTED root
file (Build-RootConfig materialises it on import; see rootconfig.yml and [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).

Each section is a titled, explained group: `title` + `why` render as the section's comment block, `patterns`
are verbatim git wildmatch lines (a bare string, or { pattern, note } for an aligned trailing comment). A
section with `inject: <provider>` takes its patterns from the caller at render time instead — the root-config
section is injected from rootconfig.yml's committed:false targets, so that list is never restated here.

Loaded via Get-Config -Config gitignore; the shape is validated by Catzc.Base.Git.GitIgnoreConfig.
```
