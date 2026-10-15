---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/Invoke-WithTimeout.ps1.md
    kind: reference
    body_sha: f2e82f024e4c
    adrs: []
---

# automation/Catzc.Base.Timeouts/Invoke-WithTimeout.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs the script block in the current runspace — it sees the same functions, modules and variables it would
see when called directly — and returns its output. A PipelineWatchdog stops it once it outlives the limit,
including a native command it is waiting on; the call then throws a TimeoutException that names the limit
and where it comes from. A terminating error inside the block is rethrown as itself; non-terminating errors
are passed on as errors of this call.
```

## comment:2

Section `.PARAMETER Budget` of the comment-based help.

```text
The work's immutable budget GUID (registered in the managed-GUID registry). While timeout-exemptions.yml exempts
it, the default limit is the exemption ceiling instead.
```

## comment:3

Section `.PARAMETER Seconds` of the comment-based help.

```text
The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption
ceiling (Get-TimeoutSeconds -Budget).
```
