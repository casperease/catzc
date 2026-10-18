# automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Removes superseded compiled C# type assemblies, keeping the current combined build.

### description

The single combined assembly in automation/.compiled/ (`Catzc.Types.<combinedHash8>.dll`) is committed to source control (a deterministic,
hash-keyed prebuild — like .vendor), so a fresh checkout and CI load it without invoking Roslyn. This tidies the cache: it keeps the one
assembly whose name matches the current combined hash of every module's `types/*.cs` and deletes the rest — older builds left over from a
previous version of a type. The current build is never deleted, so the committed file stays put on every platform.

Nothing in catzc holds a .compiled DLL open: every load goes through a per-user shadow copy (Import-TypesAssembly,
[ADR-AUTO-CACHE#8](../../../adr/automation/caching.md#rule-adr-auto-cache8)), so a superseded build is always expected to delete. A delete
that still fails means something outside catzc holds the file (an antivirus scan, an indexer, a session started before shadow loading). The
janitor removes every deletable build first, then throws one error naming each file it could not remove and, on Windows, the processes
holding it (Get-FileLockingProcess) — a silent skip is how a stale build reaches a commit. The importer catches that error into one red
line, so the load still completes.

Makes no source-control changes in a pipeline (Test-IsRunningInPipeline): CI must not modify committed files, so the delete pass is a devbox
concern — run locally so the tidied .compiled is what gets committed. The importer invokes this automatically on a devbox. In a pipeline it
enforces the one invariant instead: .compiled must hold exactly one `Catzc.Types.*.dll`, and a second one means two builds were COMMITTED —
a hard throw, the gate that stops a stale build reaching trunk.

The combined hash comes from the ONE shared implementation (Get-CombinedTypeHash in the .internal shared module) that the loader
(Import-CSharpTypes) also calls, so the janitor cannot drift from the loader and plan the live build for deletion. A test against the real
repo still guards that the live build is never planned. A devbox janitor only: in build mode
([ADR-DSGN-RUNMODE](../../../adr/design/run-modes.md)) the default code root is an installed Catzc package, whose .compiled holds the one
assembly the build produced and is never a cache to tidy, so the call is a no-op that reports why. An explicit -AutomationRoot other than
the loaded code root is still cleaned in either mode.

### parameter `AutomationRoot`

Path to the automation directory (the parent of .compiled/). Defaults to the loaded code root (Get-CatzcModulesRoot).

### parameter `DryRun`

Return the list of cache files that would be deleted, without deleting anything.

### parameter `Silent`

Suppress the per-file and end-state 'type cache: …' messages. The importer passes this on its automatic janitor call so a normal load stays
quiet (importer.ps1 -Verbose turns it back on); a manual Clear-ModuleTypeCache omits it, so a hand-run always reports the state it left. A
failed delete still throws.

### parameter `StopLockingProcesses`

The kill switch. When a superseded build will not delete, stop every process holding it (Stop-FileLockingProcess: never this session or an
ancestor of it, each stop announced even under -Silent), then retry the delete over a short bounded window (Windows releases an exited
process's mapped image a moment after the exit). A build still held afterwards — by this session itself, say — is named in the error as
usual. Off by default: stopping a process can lose its unsaved work, so it is asked for, never assumed.

### example 1

```powershell
Clear-ModuleTypeCache
```

### example 2

```powershell
Clear-ModuleTypeCache -StopLockingProcesses   # stop the sessions holding stale builds, then delete them
```

### example 3

```powershell
Clear-ModuleTypeCache -DryRun
```

## comment:1

Above `if (Test-IsRunningInPipeline) {`, written with `#`.

```text
Pipeline: nothing is deleted (CI makes no source-control changes), so more than one Catzc.Types.*.dll means
two builds were COMMITTED — a hard throw, so trunk cannot carry more than one build.
```

## comment:2

Above `Import-InternalModule Types`, written with `#`.

```text
Keep exactly the current build (Catzc.Types.<combinedHash8>.dll) and prune every other Catzc.Types.*.dll.
The combined hash is the ONE implementation shared with the loader (Import-CSharpTypes), reached through
the .internal shared module — so the janitor cannot drift from the loader and plan the live build for
deletion. Import-InternalModule is a no-op when the importer already loaded it (the usual case).
```

## comment:3

Above `if ($StopLockingProcesses -and $failed.Count) {`, written with `#`.

```text
The kill switch: stop each process holding a build that would not delete, then retry the delete. Windows
releases a stopped process's mapped image a moment after the process exits, so an immediate delete still
gets access denied — retry over a short bounded window before giving up.
```

## comment:4

Above `$details = foreach ($entry in $failed) {`, written with `#`.

```text
Who holds each surviving file — best-effort: the lookup only enriches the message, so a Restart Manager
error or a non-Windows host degrades to the delete error alone.
```
