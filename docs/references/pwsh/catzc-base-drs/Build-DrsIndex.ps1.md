# pwsh/Base.Drs/Build-DrsIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Generates [index](../../../drs/index.md) — the ADR code -> rule-citation registry — from drs.yml, the single source of truth for the ADR
domain structure.

### description

index.md is a derived projection of pwsh/Base.Drs/configs/drs.yml: authored preamble and authoring-convention prose wrapped around one
code-registry table per domain (in declared order). Every ADR row is `| ``<external>`` | [<slug>](<path>) |` — the format Get-CatsDrsIndex
parses and the citation grammar Show-Cats presents. Each link path is resolved to the real `docs/drs/<domain>/**/<slug>.md` file.

The index is committed — so GitHub has it, and every ADR citation's link resolves there — marked linguist-generated so its diff collapses,
and reproduced on every import (before Build-Readme, which generates the docs/drs README from it), so drs.yml is the ONLY place the registry
is edited — a hand-edit to index.md is overwritten on the next load. See [ADR-REPO-README](../../../drs/repository/generated-readmes.md) for
the generated-file pattern.

Idempotent and fast: the write goes through Write-FileIfChanged (canonical output, EOL-insensitive compare, write only on drift), so a clean
tree costs one file read.

### parameter `DryRun`

Report whether index.md would change without writing it. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### parameter `Silent`

The wrote / would-write status line is verbose-level — -Silent suppresses it (used by the importer tail).

### parameter `PassThru`

Return a result object ({ Path; Changed; DryRun }) instead of the repo-relative path.

### outputs

`[string]` The repo-relative path of the generated index (with -PassThru, the result object instead).

### example 1

```powershell
Build-DrsIndex
Regenerates docs/drs/index.md from drs.yml.
```

### example 2

```powershell
Build-DrsIndex -DryRun -PassThru
Reports whether the on-disk index is stale without writing it.
```

## comment:1

Above `$reflow = {`, written with `#`.

```text
The authored prose above is wrapped for reading here, not for the page: reflow every paragraph and list item
through Format-MarkdownParagraph (Prettier's fill), so the generated page is formatter-stable
([ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED](/docs/drs/repository/uniform-formatting.md#rule-adr-repo-format-generatedartifactsformatted)). A heading and a blank
line pass through; a '- ' line opens a list item, and an indented or plain line continues the open block.
```

## comment:3

Above `$sections = foreach ($domain in $adrs.Domains) {`, written with `#`.

```text
One aligned code-registry table per domain, in declared order. Rows carry the backtick-wrapped external
code and the slug link in the exact shape Get-CatsDrsIndex parses.
```
