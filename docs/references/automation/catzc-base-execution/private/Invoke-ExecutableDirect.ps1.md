---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/private/Invoke-ExecutableDirect.ps1.md
    kind: comment-page
    body_sha: "09fc597993ea"
---

# automation/Catzc.Base.Execution/private/Invoke-ExecutableDirect.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `Push-Location $WorkingDirectory`.

```text
Run directly — output flows straight to the console handle.
No pipes, no interception. Spinners, progress bars, \r overwrites all work.
Output WILL leak to the pipeline — callers must suppress if needed.
Child scope prevents $ErrorActionPreference = 'Continue' from leaking.
```
