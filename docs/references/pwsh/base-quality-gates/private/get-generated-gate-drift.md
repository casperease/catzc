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

A writer with a `*.slide.md` input is a slide writer, and it is judged per output file: each output is stale only against its own inputs,
the slide file and the pictures that slide names (`Get-SlideInputPath`), so a commit of a picture no slide uses flags nothing. Every other
writer is judged as a whole: one newer upstream commit makes the writer stale. One `git log` over the involved globs gives the commit order
of every path.

### parameter `Writer`

The gate-checked writer row to judge.

### parameter `Writers`

Every row of the registry, whose outputs may be this writer's inputs and whose claims shape its committed files.

### parameter `Generated`

The tracked generated paths, each with its writer, as Get-GeneratedTrackedPath answers.

### parameter `RepositoryRoot`

The repository the git history is read in. Default: the repository root.

### outputs

`[string]` One line per upstream writer committed after the writer's last render, or, for a slide writer, one line per input committed after
its output; none when the writer is fresh.

### example 1

```powershell
Get-GeneratedGateDrift -Writer $render -Writers $rows -Generated $tracked
```

## Why the commits and not the file times

A checkout writes every file at one time, so file times say nothing of order. The commit that last touched a writer's outputs and the
commits that touched its generated inputs since are the same on every clone, so the verdict is the same on every machine.

## comment:1

Above `$globs = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
One log over every glob that can hold a judged file; the first commit a path appears in is its newest. Rename
detection is off: it costs most of the log's time, and a renamed path still shows in the commit that added it.
```
