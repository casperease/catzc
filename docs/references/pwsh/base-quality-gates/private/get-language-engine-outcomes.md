# pwsh/Base.QualityGates/private/Get-LanguageEngineOutcomes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Runs one language test folder under each execution engine side by side and returns each engine's outcomes or its error.

### description

An engine other than pwsh that has an executable runs in a background process of its own, which imports the repository (or the build's
entry) and runs `Get-LanguageTestOutcomes` under that engine's contract, so each engine's environment stays its own. The pwsh engine, and
any engine with nothing to run, runs in this session while those processes work. A run that throws is kept as that engine's error, and a
process that does not finish within `run_list_seconds` of `timeouts.yml` is kept as an error naming the limit. The folder takes about its
slowest engine rather than the sum of the engines.

### parameter `Language`

The language of the test folder.

### parameter `Module`

The module the test folder belongs to.

### parameter `Case`

The discovered cases; each needs its `Key` and `Name`.

### parameter `Engine`

The execution engines to run the folder under.

### parameter `EntryScript`

The engine entry of a build run; empty for the source run.

### parameter `Executable`

The language's managed tool; empty when there is none, which skips the engines.

### parameter `EngineExecutable`

Each engine's executable by engine name; a missing or empty entry skips that engine.

### parameter `Folder`

The test folder, handed to the runner.

## comment:1

Above `$jobs = @{}`, written with `#`.

```text
One engine's run sets the process's environment variables (the engine contract, uv's), so engines that are not pwsh run
each in a process of their own, started before this session's own run. The ones with nothing to run skip in this session.
```
