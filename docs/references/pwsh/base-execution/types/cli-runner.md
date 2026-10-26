# pwsh/Base.Execution/types/CliRunner.cs

The streaming process runner behind `Invoke-Executable`: it parses a command string and runs the executable directly, with no shell,
streaming stdout and stderr to the console char by char on background threads while capturing them.

## One type, runner and result

The instance is both the runner and its own result: `Run` and `RunDirect` populate the three captured fields. Every run is inside a time
safeguard, so a process that outlives its limit is killed with its whole tree and the run throws a `TimeoutException`. The limit comes from
`timeouts.yml`, resolved by the caller through `Get-TimeoutSeconds`, and `ExecutableName` gives the name it is looked up by (the first
token, quotes removed, empty for a blank command).

## Entry points

- `Run` parses the command and runs it directly. It throws when it detects shell operators (`|`, `&&`, `||`, `;`).
- `RunBytes` runs silently and captures stdout as raw bytes in `StdoutBytes`, with no decoding and no console echo, for a binary stream such
  as `git cat-file --batch`, whose object sizes count bytes, not characters. Stderr is captured as text, stdin is empty and closed, and the
  single-command rule and time safeguard are the same as for `Run`.

## Starting the child

The executable is resolved on PATH with the common extensions (on Windows `.exe`, `.cmd`, `.bat`, `.com`, in `cmd.exe`'s PATHEXT order; on
Unix the bare name), because `Process.Start` without a shell resolves only exact file names and tools such as az, poetry and npm are `.cmd`
scripts on Windows.

A child that inherits a stdin pipe another thread is blocked reading can hang at startup (Git for Windows probes its standard handles).
Whenever no person can answer a prompt anyway, that is a silent run or a caller whose stdin is not a terminal, the child gets an empty,
closed stdin and reads end-of-file. A visible run from a terminal keeps its stdin, so interactive prompts still work.

## Supervision

Both limits must be positive: the time limit bounds the process, and the drain limit bounds how long the output readers may take to reach
end-of-stream once the process has exited. The rest of a finished process's output drains in milliseconds, so a reader still blocked after
the drain limit is waiting on a pipe that a process the command started (a detached server, a grandchild) still holds open. The wait is
bounded too: past the time limit the whole tree is killed and a `TimeoutException` is thrown, and a reader the pipe never releases fails the
run with an `IOException` naming the cause, instead of hanging the caller for that holder's lifetime.

The readers are background threads, so one still blocked on a pipe a leftover process holds can never keep the host alive. They swallow the
error a disposed stream raises, since an exception escaping a thread would end the host.

## Command parsing

The command string splits into the executable and its arguments, honouring single and double quoted regions, and the parser detects the
unquoted shell operators that would need a shell.
