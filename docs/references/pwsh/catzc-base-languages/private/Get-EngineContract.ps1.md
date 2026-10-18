# pwsh/Catzc.Base.Languages/private/Get-EngineContract.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the engine start environment a test language's tests start the engine by: the environment variables a runner sets for its tool's
commands.

### description

A Go or Python test starts the engine as a process and asserts on its output
([ADR-AUTO-GO-BLACKBOXTESTS](../../../../adr/automation/go/go-test-artifacts.md#rule-adr-auto-go-blackboxtests),
[ADR-AUTO-PY-BLACKBOXTESTS](../../../../adr/automation/python/python-test-artifacts.md#rule-adr-auto-py-blackboxtests)). How to start it
comes from the execution engine model, never from the test ([ADR-AUTO-ENGINE](../../../../adr/automation/execution-engines.md)), so the same
test runs under every engine:

```text
CATZC_ENGINE             the engine's name (ExecutionEngines.Names);
CATZC_ENGINE_EXECUTABLE  the engine's executable;
CATZC_ENGINE_ENTRY       the script that loads catzc into the engine: the PowerShell entry for pwsh, the
                         repository's importer.sh (forward-slashed) for the POSIX engines — what a Bash test
                         loads;
CATZC_ENGINE_START       the arguments after it, as a JSON array (ExecutionEngine.StartArguments): they start the
                         engine non-interactively, load its importer with the output discarded, and end in the
                         command text, where the test puts its catzc command in place of {command};
CATZC_IMPORTER           the POSIX engines only: the PowerShell entry the cats dispatcher loads (importer.sh reads
                         it);
CATZC_REPOSITORY_ROOT    the repository root.
```

The PowerShell entry is the repository's importer.ps1 for a source run, or -EntryScript (the build's Import-Catzc.ps1) for a build run. pwsh
loads it directly. The POSIX engines load the repository's importer.sh, whose cats dispatcher loads it through CATZC_IMPORTER, so a POSIX
engine's session drives the build too.

### parameter `Engine`

The execution engine: pwsh (default), or any other of ExecutionEngines.Names.

### parameter `EngineExecutable`

The engine's executable, already located by the caller (a test run's source session hands it down, since a build run's engine does not carry
the tools.yml entry a POSIX engine is located through). Default: Resolve-EngineExecutable.

### parameter `EntryScript`

The PowerShell entry for a build run. Default: the repository's importer.ps1 (the source run).

### outputs

`[System.Collections.Specialized.OrderedDictionary]` The variables, by name.

### example 1

```powershell
$contract = Get-EngineContract -Engine bash -EntryScript $buildEntry
```

## comment:1

Above `$entry = if ($model.Name -eq [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) {`, written with `#`.

```text
The entry the engine itself loads: pwsh the PowerShell entry; any other engine its own importer in the repository,
forward-slashed so a POSIX shell on Windows reads the path.
```
