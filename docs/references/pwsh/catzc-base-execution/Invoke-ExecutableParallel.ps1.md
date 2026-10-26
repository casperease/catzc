# pwsh/Base.Execution/Invoke-ExecutableParallel.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs independent commands side by side, a few at a time, and returns one result per command in their order.

### description

The parallel form of Invoke-Executable for a tool whose work splits into independent calls, such as a formatter's command-line batches or
a spell check's shards. Each command runs as Invoke-Executable runs it, with no shell and no shell operators, through CliRunner.RunMany:
silently, since output from several processes cannot stream to one console, and each bounded by its executable's own time limit
(Get-TimeoutSeconds). The throttle defaults to the timeouts config's `parallel.processes`, declared once on TimeoutsConfig, so a shared
devbox is never starved. Every command finishes before a failure is raised, so none is left running behind it.

A non-zero exit fails the call, naming each failed command and its exit code; -NoAssert returns the results instead. A real launch inside a
unit test throws, as Invoke-Executable's tripwire does, so a caller's L0 tests mock this one function.

### parameter `Command`

The command lines to run, each one command with its arguments. An empty list runs nothing and returns nothing.

### parameter `ThrottleLimit`

The most processes at once. Defaults to the timeouts config's `parallel.processes`.

### parameter `NoAssert`

Return the results of failed commands instead of throwing.

### parameter `Silent`

Print no line about the run.

### parameter `WorkingDirectory`

The folder every command runs in. Defaults to the repository root.

### parameter `DryRun`

Return the command lines without running any.

### outputs

`[Catzc.Base.Execution.CliResult]` One per command, in the order of -Command.

### example 1

```powershell
$results = Invoke-ExecutableParallel -Command 'prettier --list-different a.md', 'prettier --list-different b.md' -NoAssert
```
