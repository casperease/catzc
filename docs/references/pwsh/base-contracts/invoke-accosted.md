# pwsh/Base.Contracts/Invoke-Accosted.ps1

The runner of an accosted file: it executes each run under every execution engine and returns what each engine did, so one file proves the
same calls work in pwsh and through cats.

## help

### synopsis

Runs every run of an accosted file under each execution engine and returns one result per run and engine.

### description

The file is read and checked by Get-AccostedFile ([ADR-AUTO-ACCOSTED](../../../drs/automation/accosted-language.md)). Under each engine,
each run's commands are written as that engine's call text and joined with `&&`, so a failing call stops its run, and the run is started
through the engine's importer entry in the repository root, bounded by the test time limit the accosted config names. An engine whose
executable cannot be resolved returns its runs with no exit code and the reason as their output, instead of throwing.

### parameter `Path`

The accosted file, absolute or relative to the repository root.

### parameter `Engine`

The execution engines to run the file under. Default: every engine.

### parameter `RepositoryRoot`

The repository the runs start in, and whose command contracts the calls are checked against. Default: Get-RepositoryRoot.

### outputs

`[Catzc.Base.Contracts.AccostedRunResult[]]` One per run and engine: the run's number, the engine, its exit code, the call text and its
output.

### example 1

```powershell
Invoke-Accosted pwsh/Catzc.Widget/tests/widget.accosted.yml -Engine pwsh | Where-Object ExitCode -ne 0
```

## the call line of a run

Every command of a run takes the engine's prefix itself, and the commands are joined with `&&`, so the first failing call stops the run.
