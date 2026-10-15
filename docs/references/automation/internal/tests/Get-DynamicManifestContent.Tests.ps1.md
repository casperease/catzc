---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Get-DynamicManifestContent.Tests.ps1.md
    kind: test-asset
    body_sha: "23598c39eb47"
---

# automation/.internal/tests/Get-DynamicManifestContent.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
A merged module — every function in one <Module>.ps1 — loads through its explicit manifest with only the
listed publics exported and the private still callable from them (shared module scope).
```

## comment:2

Above `BeforeAll {`.

```text
A source module: a modules root holding the real shared loader under .internal/assets and one module folder of
function files. Its derived manifest loads every file into one module: publics exported, the private callable
from them but not exported, and each function still reporting its own source file and line.
```

## comment:3

Above `$result = Test-BuildArtifact -Facet Manifest -PassThru -OutputFolder...`.

```text
The published manifest is a versioned immutable artifact, so its canonical form must equal what the
repo formatter would produce — otherwise a later touch would re-format and churn the gold bytes. Every
<Module>.psd1 in a build comes from Get-DynamicManifestContent (New-DynamicManifest).
```
