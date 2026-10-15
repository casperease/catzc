---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/private/Invoke-ExecutableStreamed.ps1.md
    kind: reference
    body_sha: "8eaba377d985"
    adrs: []
---

# automation/Catzc.Base.Execution/private/Invoke-ExecutableStreamed.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Private implementation for Invoke-Executable (default mode).

Uses a C# CliRunner class (types/CliRunner.cs) that reads stdout/stderr
char-by-char on background threads via Console.Write. Preserves \r
carriage returns (spinners, progress bars) and Unicode. Output bypasses
PowerShell's output stream entirely — zero pipeline leaks.

Limitation: ANSI color codes are NOT preserved. When stdout is redirected
to a pipe (which Process does internally), most CLI tools detect this via
isatty() and disable colored output. This is a fundamental OS-level
constraint — the child process never emits the escape sequences. Solving
this would require ConPTY (pseudo-terminal). Use -Direct when colors
are important and pipeline leaks are acceptable.
```

## comment:2

Section `.PARAMETER AsBytes` of the comment-based help.

```text
Capture stdout as its exact bytes (CliResult.Bytes) instead of text, with no console echo — for a binary
stream. Returns the CliResult as -PassThru does.
```

## comment:3

Above `$suppressOutput = [bool]$Silent -or [bool](Get-Variable -Name...`.

```text
During a Pester run, also suppress the child's streamed output. CliRunner echoes stdout/stderr via
Console.Write, which bypasses the Write-Message/Write-Object suppression (so a real tool's chatter —
e.g. an `az bicep` upgrade nag — would otherwise leak into test logs). Output is still captured into
the result, so -PassThru and the exit-code assertion are unaffected. Same global the writers read,
set by Test-Automation. Read through Get-Variable: the flag is unset outside a test run, and strict mode
rejects an unset variable even when scope-qualified.
```
