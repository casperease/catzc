---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/Invoke-WithProgress.ps1.md
    kind: comment-page
    body_sha: "280a86e8851c"
---

# automation/Catzc.Base.Execution/Invoke-WithProgress.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$writersPath = (Get-Module Catzc.Base.Writers).Path`, written with `#`.

```text
The dot writer runs in a thread job with its own runspace: it streams to this host, imports the same
Writers module this session loaded, and copies this session's Pester-run guard, so its dots behave
exactly like a Write-Message on this thread.
```

## comment:2

Above `$dotJob | Remove-Job -Force`, written with `#`.

```text
Stop and remove without Receive-Job: the dots already streamed, and receiving would replay them.
-Force: Stop-Job can return while a thread job is still Stopping, and a plain Remove-Job throws then.
```
