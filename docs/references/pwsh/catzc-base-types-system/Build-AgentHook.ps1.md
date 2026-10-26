# pwsh/Base.TypesSystem/Build-AgentHook.ps1

The command that publishes the Claude Code agent hooks, the small C# programs under `.claude/hooks/`, whose source has changed.

## help

### synopsis

Publishes the Claude Code agent hooks (small C# programs under .claude/hooks/) whose source has changed.

### description

Each folder under .claude/hooks/ that holds a .csproj is one hook: Assert-BashTimeout runs before every Bash call an agent makes and denies
a call that does not run inside the safeguard
([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../../drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait));
Record-AgentWrite records what an agent session writes, so the listen mode tells it from the editor's changes
([ADR-REPO-AI-EDITORISFACT](../../../drs/repository/ai-agent-contract.md#rule-adr-repo-ai-editorisfact)). A hook is a compiled program
rather than a script because it runs that often: it starts in about a third of the time pwsh does. This publishes each, framework-dependent,
to .claude/hooks/bin/ (gitignored), and records a hash of its sources beside it as `<AssemblyName>.source.sha256`; while the hash matches
and the program is present, it does nothing, so the importer can run it on every import.

dotnet runs through Invoke-Executable rather than Invoke-Dotnet: that wrapper lives in the Tooling layer, which this Base module must not
depend on, so dotnet must be on PATH. The hooks' C# code lives in the source tree, so it stops with a named error in build mode
(Assert-SourceTree, [DDR-RUNMODE](../../../drs/design/run-modes.md)).

### parameter `Name`

The hooks to publish, by folder name. Default: every hook folder under .claude/hooks/.

### parameter `OutputDirectory`

Where to publish the hooks. Defaults to .claude/hooks/bin/, the path .claude/settings.json runs them from.

### parameter `Force`

Publish even when the source hash recorded at the last publish matches.

### parameter `ListStale`

Name the hooks whose source hash no longer matches the published program, and publish nothing. The one comparison Build-AgentHook makes,
asked without acting on it.

### outputs

`[string]` each published program's path, in folder-name order; with ListStale, the folder name of each stale hook.

### example 1

```powershell
Build-AgentHook
```

### example 2

```powershell
Build-AgentHook -Name Assert-BashTimeout -Force
```

## Which sources count

The sources are the hook folder's `*.cs` and `*.csproj` files plus every linked `<Compile Include>` (the module types the hook compiles in),
so a change to any of them republishes the hook.

## The program's name

The program's name is the project's `AssemblyName`, the one place it is set. The publish adds the platform's executable extension (if any),
so the program is found as an application by that name, never by a guessed suffix.

## No build server outlives the publish

The publish runs with `--disable-build-servers`: no MSBuild node or compiler server outlives it. A server started here would inherit the
call's output pipe and hold it open for its whole idle lifetime (minutes), so the caller, the importer or a test run priming a snapshot,
would wait on that pipe long after `dotnet` itself exited.
