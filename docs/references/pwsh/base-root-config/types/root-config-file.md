# pwsh/Base.RootConfig/types/RootConfigFile.cs

One managed root-file entry from `configs/rootconfig.yml`: a repository-root `target` fully managed by the source-of-truth automation. It
mirrors a `rootconfig.yml` files entry (snake_case keys).

## Keys

- **`target`** — the repository-root-relative path of the managed file (for example `.editorconfig`), or a wildcard pattern over the files a
  generator renders (for example `go/tests/*/go.mod`). Required.
- **`source`** or **`generator`** — exactly one of the two supplies the content: `source` is an authored file copied out, `generator` is the
  name of the function that renders the target's full content (for example `New-Importer`).
- **`optIn`** — default false; activates the entry.
- **`committed`** — default false; true keeps the managed target tracked in git instead of gitignored, for files needed before the importer
  runs (`importer.ps1`, the git files).
- **`carrier`** — names the file-carriers entry that says where the generated-file head goes (default: the carrier of the target's file
  language).
- **`sources`** — lists the authored files a generator renders from, for its head.

## Wildcard targets

A `target` holding a wildcard (`*`, `?`, `[`, for example `go/tests/*/go.mod`) names a set of files and is allowed only on a `generator`
entry: the generator returns one `{ Target; Content }` record per file, and each record's path must match the pattern. Paths are
repository-root-relative, `/`-separated communication-form values (see [ADR-AUTO-PATH](../../../../drs/automation/path-representation.md)).

## Base type

It derives from `Catzc.Base.Objects.DictionaryRecord`, so an instance also presents as a read-only dictionary over its own properties and
its constructor uses the base's extraction helpers.
