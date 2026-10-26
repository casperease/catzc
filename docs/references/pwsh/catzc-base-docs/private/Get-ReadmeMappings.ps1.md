# pwsh/Base.Docs/private/Get-ReadmeMappings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `foreach ($dir in @(Get-ChildPath -Path $prefixPath -Depth 1 -Directory |...`, written with `#`.

```text
The bounded folder walker lists the immediate subdirectories of the prefix, one level deep
([ADR-PWSH-ENUM-ALWAYSBOUNDED](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)), sorted so the
generated list keeps one order. '*' excludes dot-prefixed infrastructure folders, which the loop skips by their leaf name.
```

## comment:2

Above `$kebab = [Catzc.Base.Objects.NameCase]::Render($leaf, 'kebab')`, written with `#`.

```text
{kebab} kebab-cases the folder name, as a module's article is named; {name} keeps it, as a python
package's is.
```

## comment:3

Above `$absent.Add([pscustomobject]@{ folder = $folder; source = $source })`, written with `#`.

```text
No authored source yet: Build-Readme skips it so the importer never throws, and -Missing hands it to
the gate.
```
