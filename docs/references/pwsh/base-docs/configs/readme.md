# pwsh/Base.Docs/configs/readme.yml

The README registry, the single authored source for every generated `README.md`. Each generated `<folder>/README.md` is a copy of an
authored docs `source`, with the source's relative links rebased to the README's folder so they work where the README is opened, under a
line naming the source as the one place to edit (`Build-Readme`). The README is gitignored, since the `source` under `docs/` is what the
markdown and spelling quality gates check, and the importer regenerates it on every load. A folder not covered here keeps a hand-authored,
committed README (opt-out) and is un-ignored in `.gitignore`. See [ADR-REPO-README](../../../../drs/repository/generated-readmes.md).

The shape is validated by [DocsConfig](../types/docs-config.md); the file is read through `Get-Config -Config readme`, and the patterns
are expanded by `Get-ReadmeMappings`. All paths are repository-root-relative and forward-slashed, the communication form
([ADR-AUTO-PATH](../../../../drs/automation/path-representation.md)).

## Ways a folder gets a source

- **`patterns`** — a glob whose every matched folder derives its source by convention. Only a trailing `/*` is supported: `<prefix>/*`
  matches the immediate, non-dot-prefixed subdirectories of `<prefix>`, so `.vendor` and `.internal` never match. A pattern holds no source:
  the matched module's article is the one the comment-pages resolver derives from `configs/comment-pages.yml`. A matched folder whose
  derived article does not exist is skipped, so a module with no reference article yet is fine.
- **`mappings`** — an explicit folder-to-source entry for a folder that does not follow a convention. An explicit mapping wins over any
  pattern that also matches its folder.
- **`without_article`** — a pattern-matched folder that is allowed to have no source article, with its reason; `Test-GeneratedReadmes`
  otherwise reports it.

## Notable mappings

- The DRS folder's README is generated from its index. It is the same folder, so the index's relative links need no rebasing
  ([ADR-REPO-README-WORKINGLINKS](../../../../drs/repository/generated-readmes.md#rule-adr-repo-readme-workinglinks)).
- Every `.gitkeep` folder is backed by a reference article (the `Build-GitKeep` integrity check), because the generic `.gitkeep` points at
  the README these mappings copy in. The three template-kind folders share one source.
