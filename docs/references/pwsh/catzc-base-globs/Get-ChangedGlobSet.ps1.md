# pwsh/Catzc.Base.Globs/Get-ChangedGlobSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The globsets a diff touches — the computed area-of-control of a change.

### description

Reflects a change into the globset registry: returns every declared globset whose scan program (GlobSet.Matches, last-match-wins
[FDR-CD-GLOBS-TRACKEDFILESONLY](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)) selects at least one
changed path. The "which areas of control did this change touch" fact, computed from git at the real refs — reading the merged tree as it
actually is, so it is immune to the squash-merge and concurrent-merge staleness a per-set hash frozen on a branch would suffer, and correct
across renames (Get-ChangedFile splits a rename into both of its paths).

The changed paths come either explicitly (-ChangedFile, a pure and testable call) or from a git range (-Range) resolved through
Get-ChangedFile. -IncludeModules also matches the derived per-module sets (Get-ModuleGlobSet), so a report can name the changed modules, not
only the declared units.

In a pipeline this is the "is there anything here for us to process?" gate: a deployable unit's stage asks whether its own set is in the
returned list and stops early when it is not. The reference commit that range is measured from is the resolver's job, never this function's.

It rests on [FDR-CD-GLOBS-NAMEDGLOBSETS](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-namedglobsets).

### parameter `ChangedFile`

The changed repo-relative, '/'-separated paths to reflect (e.g. a diff's file list). May be empty.

### parameter `Range`

A git diff range to resolve the changed paths from, e.g. 'HEAD^1..HEAD'.

### parameter `IncludeModules`

Also match the derived module globsets, not only the declared registry.

### outputs

`[Catzc.Base.Globs.GlobSet]` Each touched set — declared sets in registry order, then, with -IncludeModules, the touched derived module
sets.

### example 1

```powershell
Get-ChangedGlobSet -Range 'HEAD^1..HEAD'
```

### example 2

```powershell
Get-ChangedGlobSet -ChangedFile @('infrastructure/modules/network/main.bicep')
```
