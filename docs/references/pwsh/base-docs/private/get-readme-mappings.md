# pwsh/Base.Docs/private/Get-ReadmeMappings.ps1

The resolver of the [readme registry](../configs/readme.md): it turns the patterns and mappings into the concrete folder-to-source list
that `Build-Readme` generates and `Test-GeneratedReadmes` checks.

## Expanding a pattern

The bounded folder walker lists the immediate subdirectories of the prefix, one level deep
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)), sorted so the
generated list keeps one order. A `*` excludes dot-prefixed infrastructure folders, which the loop skips by their leaf name.

In the source template `{kebab}` kebab-cases the module's full name, as a module's article is named; `{name}` keeps the full name in its
track's join form, as a Python package's is.

## A missing article

A folder with no authored source yet is skipped, so `Build-Readme` never makes the importer throw; `-Missing` hands the skipped folders to
the gate.

## help

### synopsis

Resolves the readme config into the concrete folder -> source README copy-in list Build-Readme generates.

### description

Expands each `patterns` glob against the filesystem and merges the result with the explicit `mappings`. A pattern's `source` template has
its `{kebab}` placeholder replaced with the matched folder's leaf name rendered in the kebab case of NameCase (pwsh/Azure.DevOps ->
docs/references/pwsh/catzc-azure-dev-ops.md). A matched folder whose derived source file does not exist is skipped, so a module with no
reference article yet simply gets no generated README — the importer runs Build-Readme on every load and must never throw when a source is
missing. An explicit mapping WINS over a pattern that targets the same folder.

Only a trailing `/*` glob is supported: `<prefix>/*` matches the immediate, non-dot-prefixed subdirectories of `<prefix>`. The globs expand
over the catzc source tree, so it runs in source mode only (Assert-SourceTree). See
[ADR-REPO-README](../../../../drs/repository/generated-readmes.md).

### parameter `Config`

The parsed readme config (Get-Config -Config readme): a `{ patterns; mappings }` object.

### parameter `RepositoryRoot`

Repository root the globs and source paths resolve against. Defaults to Get-RepositoryRoot.

### parameter `Missing`

Returns the skipped folders instead: one `{ folder; source }` object per pattern-matched folder whose derived source file does not exist,
which Test-GeneratedReadmes reports.

### outputs

`[object[]]` One `{ folder; source }` object per generated README — explicit mappings first, then the pattern-derived folders in filesystem
order.
