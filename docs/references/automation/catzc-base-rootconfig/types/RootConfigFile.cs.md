---
catzc:
  immutable:
    with_body_sha: "634c3ccea400"
    path: docs/references/automation/catzc-base-rootconfig/types/RootConfigFile.cs.md
    folder: docs/references/automation/catzc-base-rootconfig/types
    name: root-config-file-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.RootConfig/types/RootConfigFile.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One managed root-file entry from configs/rootconfig.yml — a repository-root `target` fully managed by the
source-of-truth automation. Exactly one of `source` (an authored file copied out) or `generator` (a function
that renders the content, e.g. New-Importer) supplies the content. `optIn` (default false) activates the
entry; `committed` (default false) keeps the managed target tracked in git instead of gitignored (for files
git or the bootstrap reads before the importer runs). `carrier` names the file-carriers entry that says where
the generated-file head goes (default: the carrier of the target's file language). `sources` lists the authored
files a generator renders from, for its head. `copyAsLink` (default false) materialises the target as a
filesystem link to the source instead of a generated copy: it requires `source`, requires committed false,
and forbids a declared `carrier` (a link carries no generated content). A `target` holding a wildcard (`*`, `?`, `[`, e.g.
go/tests/*/go.mod) names a set of files and is allowed only on a `generator` entry: the generator returns one
{ Target; Content } record per file, and each record's path must match the pattern. Paths are
repository-root-relative, '/'-separated communication-form values (see
[ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)). Mirrors a rootconfig.yml files entry (snake_case
keys).

Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
over its own properties and its constructor uses the base's extraction helpers.
```

## comment:2

Above `public string target { get; }`, written with `//`.

```text
Repository-root-relative path of the managed file (e.g. ".editorconfig"), or a wildcard pattern over the
files a generator renders (e.g. "go/tests/*/go.mod"). Required.
```

## comment:3

Above `public string generator { get; }`, written with `//`.

```text
Name of the function that renders the target's full content (e.g. "New-Importer"). Exactly one of
source/generator.
```

## comment:4

Above `public bool committed { get; }`, written with `//`.

```text
Keep the managed target tracked in git (true) instead of gitignored (false, the default). For files
needed before the importer runs (importer.ps1, the git files).
```

## comment:5

Above `public bool copyAsLink { get; }`, written with `//`.

```text
Materialise the target as a filesystem link to the source (Set-FileLink) instead of a generated copy.
Requires source, requires committed false, forbids a declared comment.
```
