# pwsh/Base.CodeMeta/configs/comment-pages.yml

The map from a source folder to the docs folder that holds its comment pages. A comment page is the one living copy of a file's long
comments, and this file says where each file's page lives; `Get-CommentPage` reads it and
[CommentPageMap](../types/CommentPageMap.cs.md) is its typed record.

## Entries

Each `pages:` entry has two keys, and the first entry that covers a file decides:

- **`source`** — a repository-relative folder, or `<prefix>/*` for each immediate subfolder of the prefix.
- **`docs`** — the folder under `docs/` the pages go under. With a `/*` source it may carry `{kebab}`, the matched module's name in the kebab
  case of `NameCase`.

The page keeps the file's name and extension plus `.md`, so every page maps back to exactly one file:
`pwsh/Base.QualityGates/Format-Code.ps1` has the page `docs/references/pwsh/catzc-base-quality-gates/Format-Code.ps1.md`.

## Hidden folders

A `<prefix>/*` source never matches a dot-prefixed subfolder, so `.vendor` has no pages and `.scriptanalyzer` and `.internal` are listed by
name, each with an entry of its own.
