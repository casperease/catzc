# automation/Catzc.Base.Reports/Clear-Output.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Removes the output that output-formats.yml no longer keeps: old run stamps, stale session files, superseded builds.

### description

Each format's area sets how many stamps or files stay and how old they may grow; a file no format covers is
reported, never removed.

It rests on [ADR-AUTO-DRYRUN#1](../../../adr/automation/dry-run.md#rule-adr-auto-dryrun1) and [ADR-REPO-OUTDIR#7](../../../adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir7).

### parameter All

Remove everything under the output root but its .gitkeep and the plan files, which cannot be regenerated,
whatever the formats keep.

### parameter DryRun

Report what would be removed without removing anything.

### parameter PassThru

Return { Removed; Uncovered; UnitCount; DryRun } instead of only the removed paths.

### outputs

`[string[]]` the output-root-relative paths removed (or, under -DryRun, that would be); with -PassThru, the result object.

### example 1

```powershell
Clear-Output -DryRun
```

### example 2

```powershell
Clear-Output -All
```
