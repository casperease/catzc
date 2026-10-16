---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Set-RedirectedOutputEncoding.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3b6725043936"
---

# automation/.internal/tests/Set-RedirectedOutputEncoding.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:sandbox = Join-Path ([System.IO.Path]::GetTempPath())...`, written with `#`.

```text
An isolated sandbox = importer + the .internal shared modules + vendor, with no application modules, imported in a
fresh child pwsh (the same shape as Import-AllModules.Tests.ps1). Capturing the child's output redirects its
standard output, which is the case under test.
```

## comment:2

Above ``$childScript = ". '$script:sandbox/importer.ps1' -Verbose 4>&1 6>`$null; " +``, written with `#`.

```text
ONE cold import, with its verbose load record merged into the captured output. The child gets its own console
(CreateNoWindow): assigning the output encoding sets the code page of the console a process is attached to, so a
child sharing this worker's console would inherit whatever the worker's own import already set.
```
