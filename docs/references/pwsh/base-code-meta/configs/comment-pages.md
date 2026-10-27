# pwsh/Base.CodeMeta/configs/comment-pages.yml

The map from a source folder to the docs folder that holds its comment pages. A comment page is the one living copy of a file's long
comments, and this file says where each file's page lives; `Get-CommentPage` reads it and `CommentPageMap` is its typed record.

## Entries

Each `pages:` entry has two keys, and the first entry that covers a file decides:

- **`source`** — a repository-relative folder, or `<prefix>/*` for each immediate, non-dot-prefixed subfolder of the prefix (a module).
- **`docs`** — a plain folder under `docs/` the pages go under; it holds no pattern, since the module, aspect and file parts below it are
  derived.

The page of a file is `<docs>/[<module>/][<aspect path>/]<file>.md`, every part in the normal form (the kebab case of `NameCase`), with the
file's trailing extension and its `.Tests` role dropped. A module folder's article is `<docs>/<module>/index.md`. Every page maps back to
exactly one source: `pwsh/Base.QualityGates/Format-Code.ps1` has the page `docs/references/pwsh/base-quality-gates/format-code.md`.

## Articles and exclusions

`articles:` lists the authored pages under a `docs` folder that no source file has, and `exclude:` lists the folders whose files have no
page, such as vendored scripts we ship but do not write.

## Hidden folders

A `<prefix>/*` source never matches a dot-prefixed subfolder, so `.vendor` has no pages and `.scriptanalyzer` and `.internal` are listed by
name, each with an entry of its own.
