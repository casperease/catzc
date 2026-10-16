---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/private/Invoke-ExecutableStreamed.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "2e95f6eef7c2"
---

# automation/Catzc.Base.Execution/private/Invoke-ExecutableStreamed.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$suppressOutput = [bool]$Silent -or [bool](Get-Variable -Name...`, written with `#`.

```text
During a Pester run, also suppress the child's streamed output. CliRunner echoes stdout/stderr via
Console.Write, which bypasses the Write-Message/Write-Object suppression (so a real tool's chatter —
e.g. an `az bicep` upgrade nag — would otherwise leak into test logs). Output is still captured into
the result, so -PassThru and the exit-code assertion are unaffected. Same global the writers read,
set by Test-Automation. Read through Get-Variable: the flag is unset outside a test run, and strict mode
rejects an unset variable even when scope-qualified.
```
