---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/private/Invoke-ExecutableStreamed.ps1.md
    kind: comment-page
    body_sha: "58c0729f3ca9"
---

# automation/Catzc.Base.Execution/private/Invoke-ExecutableStreamed.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$suppressOutput = [bool]$Silent -or [bool](Get-Variable -Name...`.

```text
During a Pester run, also suppress the child's streamed output. CliRunner echoes stdout/stderr via
Console.Write, which bypasses the Write-Message/Write-Object suppression (so a real tool's chatter —
e.g. an `az bicep` upgrade nag — would otherwise leak into test logs). Output is still captured into
the result, so -PassThru and the exit-code assertion are unaffected. Same global the writers read,
set by Test-Automation. Read through Get-Variable: the flag is unset outside a test run, and strict mode
rejects an unset variable even when scope-qualified.
```
