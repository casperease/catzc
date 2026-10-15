# docs/references/automation/catzc-base-docs/configs/readme.yml.md

`automation/Catzc.Base.Docs/configs/readme.yml`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `patterns:`.

```text
README registry — the single authored source for every generated README.md.

Each generated `<folder>/README.md` is a COPY of an authored docs `source`, with the source's relative links
rebased to the README's folder so they work where the README is opened, under a line naming the source as the
one place to edit (Build-Readme). The README is gitignored (the `source` under docs/ is what the markdown and
spelling quality gates check); the importer regenerates it on every load. A folder NOT covered here keeps a
hand-authored, committed README (opt-out) and is un-ignored in .gitignore.

Two ways a folder gets a source:
  patterns:  a glob whose every matched folder derives its source by CONVENTION — the `{kebab}` placeholder
             is the matched folder's leaf name, lowercased with dots turned to hyphens
             (automation/Catzc.Azure.DevOps -> docs/references/automation/catzc-azure-devops.md). Only a
             trailing `/*` is supported: `<prefix>/*` matches the immediate, non-dot-prefixed subdirectories
             of `<prefix>` (so .vendor/.internal/… never match). A matched folder whose derived source does
             not exist is skipped (no README generated), so a module with no reference article yet is fine.
  mappings:  an explicit folder -> source entry for a folder that does not follow a convention. An explicit
             mapping WINS over any pattern that also matches its folder.

All paths are repository-root-relative and forward-slashed (communication form; see
[ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)). Loaded via Get-Config -Config readme; the shape is validated by
Catzc.Base.Docs.DocsConfig and the patterns are expanded by Get-ReadmeMappings. See
[ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```

## comment:2

Above `- folder: docs/adr`.

```text
The ADR folder's README is generated from its index — same folder, so index.md's relative links need no
rebasing ([ADR-REPO-README#6](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme6)).
```

## comment:3

Above `- folder: out`.

```text
Every .gitkeep folder is backed by a reference article (the Build-GitKeep integrity gate) — the generic
.gitkeep points at the README these mappings copy in. The three template-kind folders share one source.
```
