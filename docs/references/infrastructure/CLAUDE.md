# Authoring an infrastructure reference

This directory holds one reference article per infrastructure unit: the templating-system `overview.md`, the shared-bicep `modules.md`, and
one `<template>.md` per deployable template (named for its `infrastructure/templates/<name>/` folder — `foundation` → `foundation.md`).
`index.md` is the reader's guide and the article list; this file is the author's guide. Copy `_template.md` as the skeleton for a new
template article; when in doubt, match `foundation.md` (the smallest complete example).

Each article is also the **link source** for its folder's generated `README.md` (module `Catzc.Base.Docs`; see
[generated-readmes](../../adr/repository/generated-readmes.md)): the README is a filesystem link to the article, not a copy. The mapping
from folder to source lives in `automation/Catzc.Base.Docs/configs/readme.yml`. Author links relative to _this_ directory — the docs tree
is the reading surface where they resolve; the README is a pointer to the article, not a second rendering.

## Document structure — a template article

A template article describes a template by **what it deploys and how it is configured**, not by walking its bicep. Five parts, in order:

1. **`# <name>`** — H1, the template's folder name (`# foundation`). One H1 per file.
2. **Lead paragraph** — what the template deploys and its single responsibility; what it deliberately does not own; and any cross-template
   dependency (e.g. it needs `foundation`'s Key Vault). Link the governing ADR(s) (`../../adr/azure/...`).
3. **`## Resources`** — a bullet list of the Azure resources it creates, each naming the shared `*.bicep` module that provides it.
4. **`## Configuration`** — its `short_name` and `environment_kind`, the environments/slots it targets, the
   `configuration/<subscription>/<env>[-<slot>].yml` files shipped, and any `PrePost.psm1` behaviour.
5. **`## Modules used`** — the shared modules it references, linking [modules](modules.md).

`overview.md` and `modules.md` use lighter shapes: `overview.md` covers the folder layout and the build/deploy flow; `modules.md` lists the
shared modules and how a template references one.

## References point one way

An article cites ADRs (`../../adr/...`), sibling articles (`foundation.md`), and the automation reference
(`../automation/catzc-azure-templates.md`); an ADR or the code never links back to these articles. (Same rule as the ADR authoring
conventions.)

## Formatting & gates

- Prose wraps at **140 columns** (Prettier `proseWrap: always`). Prefer bullet lists over tables here; a wide table is exempt from the
  line-length rule but bullets read better for these short lists.
- **No raw HTML.** markdownlint `MD033` is on, so `<br>` and bare `<placeholder>` are rejected — keep any `<placeholder>` notation inside
  `code spans` (that is why the skeleton does).
- After editing, run, from the repo root:

  ```powershell
  Format-Markdown -Glob 'docs/references/infrastructure/*.md'   # wraps prose
  Test-Markdownlint
  Test-Spelling
  ```

## Adding a new template article

1. Copy `_template.md` to `<template>.md` and fill in the five parts.
2. Add a row to the table in `index.md` (article link, one-line summary).
3. Add it to `mappings:` in `automation/Catzc.Base.Docs/configs/readme.yml` so its README generates:
   `folder: infrastructure/templates/<name>` → `source: docs/references/infrastructure/<template>.md`.
4. Run the three gates above, then `. ./importer.ps1` to generate the README.
