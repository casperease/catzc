---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/private/Invoke-ExecutableDirect.ps1.md
    kind: comment-page
    body_sha: "7d71e5fce32b"
---

# automation/Catzc.Base.Execution/private/Invoke-ExecutableDirect.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Private implementation for Invoke-Executable -Direct.

Output flows straight to the console as if the command were typed
at the prompt. No buffering, no capture, no stream separation.
Just the LASTEXITCODE lifecycle (reset, execute, assert, reset).

-PassThru is accepted but ignored — there is nothing to return.
Use the default (Stream) mode when you need structured output.
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Accepted for signature compatibility. Ignored — Direct mode does not
capture output.
```

## comment:3

Above `Push-Location $WorkingDirectory`.

```text
Run directly — output flows straight to the console handle.
No pipes, no interception. Spinners, progress bars, \r overwrites all work.
Output WILL leak to the pipeline — callers must suppress if needed.
Child scope prevents $ErrorActionPreference = 'Continue' from leaking.
```

## comment:4

Above `Push-Location $WorkingDirectory`.

```text
Run directly — output flows straight to the console handle.
No pipes, no interception. Spinners, progress bars, \r overwrites all work.
Output WILL leak to the pipeline — callers must suppress if needed.
Child scope prevents $ErrorActionPreference = 'Continue' from leaking.
```
