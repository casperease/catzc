# automation/Catzc.Base.Docs/private/Get-ReadmeMappings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the readme config into the concrete folder -> source README copy-in list Build-Readme generates.

### description

Expands each `patterns` glob against the filesystem and merges the result with the explicit `mappings`. A pattern's `source` template has
its `{kebab}` placeholder replaced with the matched folder's leaf name lowercased with dots turned to hyphens (automation/Catzc.Azure.DevOps
-> docs/references/automation/catzc-azure-devops.md). A matched folder whose derived source file does not exist is skipped, so a module with
no reference article yet simply gets no generated README — the importer runs Build-Readme on every load and must never throw when a source
is missing. An explicit mapping WINS over a pattern that targets the same folder.

Only a trailing `/*` glob is supported: `<prefix>/*` matches the immediate, non-dot-prefixed subdirectories of `<prefix>`. The globs expand
over the catzc source tree, so it runs in source mode only (Assert-SourceTree). See
[ADR-REPO-README](../../../../adr/repository/generated-readmes.md).

### parameter `Config`

The parsed readme config (Get-Config -Config readme): a `{ patterns; mappings }` object.

### parameter `RepositoryRoot`

Repository root the globs and source paths resolve against. Defaults to Get-RepositoryRoot.

### outputs

`[object[]]` One `{ folder; source }` object per generated README — explicit mappings first, then the pattern-derived folders in filesystem
order.

## comment:1

Above `foreach ($dir in ([System.IO.Directory]::EnumerateDirectories($prefixPath) |...`, written with `#`.

```text
[System.IO] (sorted) rather than Get-ChildItem — the cmdlet carries ~20ms of per-call provider
overhead the raw .NET enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)). '*' excludes dot-prefixed
infrastructure folders.
```
