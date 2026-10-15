---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Set-RedirectedOutputEncoding.Tests.ps1.md
    kind: test-asset
    body_sha: "1fdf37dc77bb"
---

# automation/.internal/tests/Set-RedirectedOutputEncoding.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:sandbox = Join-Path ([System.IO.Path]::GetTempPath())...`.

```text
An isolated sandbox = importer + the .internal shared modules + vendor, with no application modules, imported in a
fresh child pwsh (the same shape as Import-AllModules.Tests.ps1). Capturing the child's output redirects its
standard output, which is the case under test.
```

## comment:2

Above ``$childScript = ". '$script:sandbox/importer.ps1' -Verbose 4>&1 6>`$null; " +``.

```text
ONE cold import, with its verbose load record merged into the captured output. The child gets its own console
(CreateNoWindow): assigning the output encoding sets the code page of the console a process is attached to, so a
child sharing this worker's console would inherit whatever the worker's own import already set.
```
