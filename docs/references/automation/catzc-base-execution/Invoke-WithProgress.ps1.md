---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/Invoke-WithProgress.ps1.md
    kind: comment-page
    body_sha: af6c2344ecd8
---

# automation/Catzc.Base.Execution/Invoke-WithProgress.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$writersPath = (Get-Module Catzc.Base.Writers).Path`.

```text
The dot writer runs in a thread job with its own runspace: it streams to this host, imports the same
Writers module this session loaded, and copies this session's Pester-run guard, so its dots behave
exactly like a Write-Message on this thread.
```

## comment:6

Above `$dotJob | Remove-Job -Force`.

```text
Stop and remove without Receive-Job: the dots already streamed, and receiving would replay them.
-Force: Stop-Job can return while a thread job is still Stopping, and a plain Remove-Job throws then.
```
