# pwsh/Base.TypesSystem/Clear-ModuleTypeCache.ps1

The janitor of the compiled C# type builds: it removes the superseded assemblies from the shadow root and keeps the current build and every
build loaded within the prune age.

## help

### synopsis

Removes superseded compiled C# type assemblies, keeping the current combined build and any build loaded within the prune age.

### description

The combined types assembly (`Catzc.Types.<combinedHash8>.dll`, with its `.json` manifest beside it) is built on each machine into the
per-user shadow root (Get-TypesShadowRoot), a per-machine cache that git never holds
([ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD](../../../drs/automation/caching.md#rule-adr-auto-cache-compiledtypeprebuild)). This tidies that
cache: it keeps the build whose name matches the current combined hash of every module's `types/*.cs`, and any build whose last load is
younger than the prune age (Get-TypesPruneAfter, the age the loader prunes by), and deletes every other build with its manifest. Every
tree's sessions share the shadow root and each load refreshes its build's write time, so a young build of another hash may be another tree's
current one. The importer runs this on every devbox import, silently.

The combined hash comes from the one shared implementation (Get-CombinedTypeHash in the .internal Types module) that the loader also calls,
so the janitor cannot drift from the loader and plan the live build for deletion; a test against the real repository guards that the live
build is never planned.

A superseded build another process still has loaded is that process's one types instance until it exits
([ADR-PWSH-TYPES-ONEINSTANCEPERSESSION](../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-oneinstancepersession)).
The janitor deletes every build it can, then names each one it could not, with, on Windows, the processes holding it
(Get-FileLockingProcess), in one yellow line: a fact, never an error, and never a reason to stop or wait. That build goes on the first run
after its holder exits.

It deletes nothing in a pipeline (Test-IsRunningInPipeline), and in build mode ([DDR-RUNMODE](../../../drs/design/run-modes.md)) it skips
the loaded package root, an installed Catzc build whose compiled assembly is the build's output, not a cache; an explicit -ModulesRoot other
than the loaded package is still cleaned. Each skip says why unless -Silent.

### parameter `ModulesRoot`

The modules folder whose current combined hash names the build to keep. Defaults to the loaded code root (Get-CatzcModulesRoot).

### parameter `DryRun`

Return the list of builds that would be deleted, without deleting anything.

### parameter `Silent`

Suppress the per-file and end-state 'type cache: …' messages. The importer passes this on its automatic janitor call so a normal load stays
quiet (importer.ps1 -Verbose turns it back on); a manual Clear-ModuleTypeCache omits it, so a hand-run always reports the state it left,
including the one yellow line that names a build another process still holds.

### example 1

```powershell
Clear-ModuleTypeCache
```

### example 2

```powershell
Clear-ModuleTypeCache -DryRun
```

## What is kept and what is pruned

The builds are a per-machine cache in the shadow root
([ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD](../../../drs/automation/caching.md#rule-adr-auto-cache-compiledtypeprebuild)); git keeps only the
manifest. The janitor keeps the current build (`Catzc.Types.<combinedHash8>.dll`) and every build loaded within the prune age, and prunes
the rest.

The combined hash is the one implementation shared with the loader (`Import-CSharpTypes`), reached through the `.internal` shared module, so
the janitor cannot drift from the loader and plan the live build for deletion. `Import-InternalModule` is a no-op when the importer already
loaded it, which is the usual case.

In a pipeline nothing is deleted: CI makes no source-control changes, and the shadow root is a devbox cache.

## A build another process holds

A superseded build another process still has open is that process's bound instance until it exits. That is a fact to name, never an error
and never a reason to stop or wait on anything
([ADR-PWSH-TYPES-ONEINSTANCEPERSESSION](../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-oneinstancepersession)).

Who holds each surviving file is looked up best-effort: the lookup only enriches the message, so a Restart Manager error or a non-Windows
host degrades to the delete error alone.
