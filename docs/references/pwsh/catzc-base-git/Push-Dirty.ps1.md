# automation/Catzc.Base.Git/Push-Dirty.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lands the working tree on the server with one fast push: stage everything, commit, push, never force.

### description

The fast push of [ADR-DSGN-LIFE#11](../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life11). Stages every change when the tree is
dirty, commits it with -Message (the editor's commit field; `...` when none is given), and pushes the current branch to origin. A tree with
nothing to commit still pushes the commits that are waiting locally.

It stops, changing nothing, in `main-via-pr` while standing on main/master (the `git_workspace` variant's one stop condition), and it never
forces: a push the server rejects because main moved is reported and left for you to integrate by hand, since rebasing would build the
commit on a tip that may be a dirty HEAD.

It rests on [ADR-AUTO-DRYRUN#2](../../../adr/automation/dry-run.md#rule-adr-auto-dryrun2).

### parameter `Message`

The commit message. Empty or omitted: `...`.

### parameter `DryRun`

Report what would be committed and pushed, and change nothing.

### outputs

`[pscustomobject]` With -DryRun: @{ Branch; HasChanges; Message }. Otherwise nothing — the outcome is reported.

### example 1

```powershell
Push-Dirty
```

### example 2

```powershell
Push-Dirty -Message 'Fix the loader'
```

### example 3

```powershell
Push-Dirty -DryRun
```
