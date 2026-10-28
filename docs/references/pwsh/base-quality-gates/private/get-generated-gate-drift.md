# pwsh/Base.QualityGates/private/Get-GeneratedGateDrift.ps1

A private helper of Test-GeneratedFiles. It judges a gate-checked writer fresh or stale from the commits, since such a writer has no dry run
to compare against.

## help

### synopsis

Names the generated input a gate-checked writer's outputs are older than, as one finding line each.

### description

A writer whose check is `gate` renders through a tool the gate cannot run in report-only mode, so freshness is read from git. The writer's
outputs are its committed files: its output globs, less the files another writer claims under them (by that writer's glob, or by path when
that writer has no row). The newest commit touching them is the render. An input of the writer is generated when another writer's output is
that very glob; for each such upstream writer, a commit of its committed files after the render is one finding line naming the upstream
writer and the short hash of its newer commit. An authored input is never judged here, the gate's own checks prove it. A writer with no
committed output has nothing to be older than anything and answers nothing.

The judgement is per writer, never per file: one newer upstream commit makes the writer stale as a whole.

### parameter `Writer`

The gate-checked writer row to judge.

### parameter `Writers`

Every row of the registry, whose outputs may be this writer's inputs and whose claims shape its committed files.

### parameter `Generated`

The tracked generated paths, each with its writer, as Get-GeneratedTrackedPath answers.

### parameter `RepositoryRoot`

The repository the git history is read in. Default: the repository root.

### outputs

`[string]` One line per upstream writer committed after the writer's last render; none when the writer is fresh.

### example 1

```powershell
Get-GeneratedGateDrift -Writer $render -Writers $rows -Generated $tracked
```

## Why the commits and not the file times

A checkout writes every file at one time, so file times say nothing of order. The commit that last touched a writer's outputs and the
commits that touched its generated inputs since are the same on every clone, so the verdict is the same on every machine.
