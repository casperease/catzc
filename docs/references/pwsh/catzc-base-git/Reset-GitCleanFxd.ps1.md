# pwsh/Catzc.Base.Git/Reset-GitCleanFxd.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Performs a whitelisted `git clean -fxd`: deletes only the untracked files the automation itself generates and owns, and leaves everything
else in place, reported.

### description

A raw `git clean -fxd` removes every untracked and ignored file — the regenerable generated artifacts AND any in-flight work that simply has
not been committed yet. This wrapper keeps the convenience and removes the hazard: it asks git what a clean would remove (`git clean -xdn`,
the dry-run listing), classifies every candidate against the in-memory auto-controlled whitelist (Get-AutoControlledGlobs — the managed
root-config targets from rootconfig.yml plus the conventional generated classes: module manifests, generated READMEs, cspell dictionaries,
out/, the IDE project's bin/obj, compiled-type scratch), deletes exactly the auto-controlled candidates through pathspec-limited
`git clean -fxd -- <paths>` calls, and reports every candidate it refused to touch — the untracked files that are NOT ours to delete.

Everything deleted is rematerialised by the next import (dot-source importer.ps1) except out/, whose content is transient by contract
(dedicated-output-directory) — gone means gone, by design. The authored plan files (`out/plan-*.md`,
[ADR-REPO-OUTDIR#10](../../../adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10)) are the exception: kept and reported.

### parameter `DryRun`

Classify without deleting: return the plan as an object with the Remove and Keep lists.

### outputs

`[pscustomobject]` With -DryRun: @{ Remove = the auto-controlled candidates that would be deleted; Keep = the untracked candidates left
alone }. Otherwise nothing — the outcome is reported.

### example 1

```powershell
Reset-GitCleanFxd -DryRun
```

### example 2

```powershell
Reset-GitCleanFxd
```

## comment:1

Above `function Reset-GitCleanFxd {`, written with `#`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:2

Above `$listing = Invoke-Executable 'git clean -xdn' -PassThru -Silent`, written with `#`.

```text
git's own dry run is the source of the candidates: exactly what `git clean -fxd` would remove, no
re-implementation of ignore semantics.
```
