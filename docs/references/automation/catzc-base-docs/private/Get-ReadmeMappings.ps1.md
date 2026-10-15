---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-ReadmeMappings.ps1.md
    kind: comment-page
    body_sha: "27dc46b1a9ed"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.Docs/private/Get-ReadmeMappings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Expands each `patterns` glob against the filesystem and merges the result with the explicit `mappings`.
A pattern's `source` template has its `{kebab}` placeholder replaced with the matched folder's leaf name
lowercased with dots turned to hyphens (automation/Catzc.Azure.DevOps ->
docs/references/automation/catzc-azure-devops.md). A matched folder whose derived source file does not exist
is skipped, so a module with no reference article yet simply gets no generated README — the importer runs
Build-Readme on every load and must never throw when a source is missing. An explicit mapping WINS over a
pattern that targets the same folder.

Only a trailing `/*` glob is supported: `<prefix>/*` matches the immediate, non-dot-prefixed subdirectories
of `<prefix>`. The globs expand over the catzc source tree, so it runs in source mode only
(Assert-SourceTree). See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```

## comment:2

Above `foreach ($dir in ([System.IO.Directory]::EnumerateDirectories($prefixPath) |...`.

```text
[System.IO] (sorted) rather than Get-ChildItem — the cmdlet carries ~20ms of per-call provider
overhead the raw .NET enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)). '*' excludes dot-prefixed
infrastructure folders.
```

## comment:3

Above `foreach ($dir in ([System.IO.Directory]::EnumerateDirectories($prefixPath) |...`.

```text
[System.IO] (sorted) rather than Get-ChildItem — the cmdlet carries ~20ms of per-call provider
overhead the raw .NET enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)). '*' excludes dot-prefixed
infrastructure folders.
```
