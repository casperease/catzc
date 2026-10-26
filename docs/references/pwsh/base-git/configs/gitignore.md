# pwsh/Base.Git/configs/gitignore.yml

The gitignore registry: the single source of truth for the repository-root `.gitignore`.

## How it becomes the file

`New-GitIgnore` renders these sections, in order, into the sectioned, commented `.gitignore`, which is itself a managed, committed root file
(`Build-RootConfig` materialises it on import; see `rootconfig.yml` and
[ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md)). It is loaded via `Get-Config -Config gitignore`, and
`Catzc.Base.Git.GitIgnoreConfig` validates its shape.

## Sections

Each section is a titled, explained group: `title` and `why` render as the section's comment block, and `patterns` are verbatim git
wildmatch lines (a bare string, or `{ pattern, note }` for an aligned trailing comment). A section with `inject: <provider>` takes its
patterns from the caller at render time instead: the root-config section is injected from `rootconfig.yml`'s `committed: false` targets, so
that list is never restated here.
