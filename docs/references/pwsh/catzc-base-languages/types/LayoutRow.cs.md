# pwsh/Base.Languages/types/LayoutRow.cs

One row of a language's module layout: a folder, its role, the extensions it places, and whether it is live and shipped.

## Shared rows

`Shared` holds the rows no single file language owns, so every module has them: assets ship with the module, tests never do. A language's
own rows (public functions at the root, `private/`, `types/`, `configs/`) are declared under it in `languages.yml`.
