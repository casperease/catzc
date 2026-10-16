---
catzc:
  immutable:
    with_body_sha: fec123dfb7a4
    repo_status: locked
    path: docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md
    folder: docs/references/automation/catzc-base-typessystem
    name: clear-module-type-cache-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
