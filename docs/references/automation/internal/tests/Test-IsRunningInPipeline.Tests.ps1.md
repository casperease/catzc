---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Test-IsRunningInPipeline.Tests.ps1.md
    kind: test-asset
    body_sha: "61ab475ef0ed"
---

# automation/.internal/tests/Test-IsRunningInPipeline.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-IsRunningInPipeline' -Tag 'L0', 'logic' {`.

```text
Test-IsRunningInPipeline lives in Catzc.Internal.Loader, which both run modes import first and keep loaded, so
no import is needed here. Each case sets the detection variables and restores them after.
```
