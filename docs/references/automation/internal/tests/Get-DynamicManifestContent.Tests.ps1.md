---
catzc:
  immutable:
    with_body_sha: "04e65cc96548"
    repo_status: locked
    path: docs/references/automation/internal/tests/Get-DynamicManifestContent.Tests.ps1.md
    folder: docs/references/automation/internal/tests
    name: get-dynamic-manifest-content-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/.internal/tests/Get-DynamicManifestContent.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {` (occurrence 3), written with `#`.

```text
A merged module — every function in one <Module>.ps1 — loads through its explicit manifest with only the
listed publics exported and the private still callable from them (shared module scope).
```

## comment:2

Above `BeforeAll {` (occurrence 4), written with `#`.

```text
A source module: a modules root holding the real shared loader under .internal/assets and one module folder of
function files. Its derived manifest loads every file into one module: publics exported, the private callable
from them but not exported, and each function still reporting its own source file and line.
```

## comment:3

Above `$result = Test-BuildArtifact -Facet Manifest -PassThru -OutputFolder...`, written with `#`.

```text
The published manifest is a versioned immutable artifact, so its canonical form must equal what the
repo formatter would produce — otherwise a later touch would re-format and churn the gold bytes. Every
<Module>.psd1 in a build comes from Get-DynamicManifestContent (New-DynamicManifest).
```
