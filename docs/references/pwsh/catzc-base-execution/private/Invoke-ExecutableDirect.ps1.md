# pwsh/Base.Execution/private/Invoke-ExecutableDirect.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs a CLI command directly with no output capture or stream separation.

### description

Private implementation for Invoke-Executable -Direct.

Output flows straight to the console as if the command were typed at the prompt. No buffering, no capture, no stream separation. Just the
LASTEXITCODE lifecycle (reset, execute, assert, reset).

-PassThru is accepted but ignored — there is nothing to return. Use the default (Stream) mode when you need structured output.

### parameter `Command`

The command string to execute.

### parameter `WorkingDirectory`

The directory to run the command in.

### parameter `PassThru`

Accepted for signature compatibility. Ignored — Direct mode does not capture output.

### parameter `NoAssert`

Skip the exit code assertion.

### parameter `Silent`

Suppress the command log line.

### parameter `DryRun`

Return the command string without executing.

## comment:1

Above `Push-Location $WorkingDirectory`, written with `#`.

```text
Run directly — output flows straight to the console handle.
No pipes, no interception. Spinners, progress bars, \r overwrites all work.
Output WILL leak to the pipeline — callers must suppress if needed.
Child scope prevents $ErrorActionPreference = 'Continue' from leaking.
```
