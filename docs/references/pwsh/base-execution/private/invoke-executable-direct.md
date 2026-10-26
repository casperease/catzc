# pwsh/Base.Execution/private/Invoke-ExecutableDirect.ps1

The implementation of `Invoke-Executable -Direct`: the command runs as if typed at the prompt, with nothing captured and nothing separated.

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

## Behaviour

The child writes straight to the console handle, so spinners, progress bars and carriage-return overwrites all work. The price is that the
output also flows into the caller's pipeline, and a caller that does not want it must suppress it. The call runs in a child scope, so an
`$ErrorActionPreference` of `Continue` set for the run cannot leak out.
