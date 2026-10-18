# automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Publishes the Claude Code Bash time-safeguard hook (a small C# program) when its source has changed.

### description

The hook (.claude/hooks/Assert-BashTimeout/) runs before every Bash call an agent makes and denies a call that does not run inside the
safeguard ([ADR-AUTO-FAILFAST#7](../../../adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)). It is a compiled program
rather than a script because it runs that often: it starts in about a third of the time pwsh does. This publishes it, framework-dependent,
to .claude/hooks/bin/ (gitignored), and records a hash of the sources beside it; while the hash matches and the program is present, it does
nothing, so the importer can run it on every import.

dotnet runs through Invoke-Executable rather than Invoke-Dotnet: that wrapper lives in the Tooling layer, which this Base module must not
depend on, so dotnet must be on PATH. The hook's C# code lives in the source tree, so it stops with a named error in build mode
(Assert-SourceTree, [ADR-DSGN-RUNMODE](../../../adr/design/run-modes.md)).

### parameter `OutputDirectory`

Where to publish the hook. Defaults to .claude/hooks/bin/ — the path .claude/settings.json runs it from.

### parameter `Force`

Publish even when the source hash recorded at the last publish matches.

### outputs

`[string]` The published program's path.

### example 1

```powershell
Build-BashTimeoutHook
```

### example 2

```powershell
Build-BashTimeoutHook -Force
```

## comment:1

Above `$sources = @(Get-ChildPath $project -File -Filter '*.cs', '*.csproj' -Depth 1...`, written with `#`.

```text
The sources are this folder's *.cs/*.csproj plus every linked <Compile Include> (the module types the hook
compiles in), so a change to any of them republishes the hook.
```

## comment:2

Above `$assemblyName = $projectXml.Project.PropertyGroup.AssemblyName | Where-Object...`, written with `#`.

```text
The program's name is the project's AssemblyName — the one place it is set. The publish adds the platform's
executable extension (if any), so the program is found as an application by that name, never by a guessed suffix.
```

## comment:3

Above ``Invoke-Executable "dotnet publish `"$csproj`" --configuration Release...``, written with `#`.

```text
--disable-build-servers: no MSBuild node or compiler server outlives the publish. A server started here would
inherit this call's output pipe and hold it open for its whole idle lifetime (minutes), so the caller — the
importer, or a test run priming a snapshot — would wait on that pipe long after dotnet itself exited.
```
