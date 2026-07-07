# Add a deployable unit (a globset and its triggers)

A deployable unit is defined exactly once, as a **globset** in `automation/Catzc.Base.Globs/configs/globs.yml` — a named set of glob
patterns over the files under version control. Pipelines and workflows trigger on the globset's **native path-filter projection** (generated
from the set, never hand-authored), and "did this change touch the unit?" is reflected from git at the real refs — nothing is committed per
set. The full model is the [durable-sha-globs](../../../adr/pipelines/durable-sha-globs.md) ADR; this page is the workflow.

## Define the globset

Add an entry to `globs.yml` — a kebab-case name, a description, `include:` patterns, and optional `exclude:` patterns:

```yaml
globsets:
  my-unit:
    description: Deployable unit - what composes it, in one line.
    include:
      - infrastructure/templates/my-unit/**
      - infrastructure/modules/**
```

The dialect: `/`-separated, repo-relative; `**` matches any depth (the only operator that crosses `/`); within a segment, patterns mean
exactly what they mean to PowerShell's `-like` (`*`, `?`, `[a-z]`), case-sensitively. Membership is include minus exclude, evaluated against
`git ls-files`. The config is strictly validated on load — an unknown key, a malformed pattern, or a cyclic compose is rejected with a named
error.

Inspect the result before committing to it:

```powershell
Get-GlobSet -Name my-unit          # the compiled set
Get-GlobSetFile -Name my-unit      # exactly the files the identity is computed over
Get-GlobSetHash -Name my-unit      # the durable SHA (the live protection identity)
Get-GlobSetTrigger -Name my-unit   # the native ADO / GitHub path-filter projection
```

## Project the trigger

`Get-GlobSetTrigger` renders the globset into each vendor's native path-filter dialect: `.AdoInclude`/`.AdoExclude` (order-independent) for
an ADO `trigger.paths` block, and `.GitHub` (ordered, `!`-negation) for a GitHub `on.*.paths` list. Both are generated from `globs.yml` —
put the generated `paths:` block into the pipeline/workflow, never a hand-picked source path:

```powershell
$t = Get-GlobSetTrigger -Name my-unit
$t.AdoInclude    # -> trigger.paths.include / pr.paths.include
$t.AdoExclude    # -> trigger.paths.exclude / pr.paths.exclude
$t.GitHub        # -> on.push.paths / on.pull_request.paths
```

## Register the consumers

Point every pipeline or workflow that should fire for this unit at its projection — and at nothing else:

- **ADO root pipeline** — `trigger:`/`pr:` `paths:` set to `.AdoInclude` / `.AdoExclude` (honored only at the pipeline root).
- **GitHub workflow** — `on.push.paths` / `on.pull_request.paths` set to `.GitHub`.
- **ADO build-validation policy** (server-side) — `Register-AdoBuildValidation my-unit` sets the policy's path filter to the same
  projection.

The exact YAML shapes are in the ADR's
[native-projection section](../../../adr/pipelines/durable-sha-globs.md#native-projection-the-no-start-trigger).

## The daily discipline

There is no per-commit marker to regenerate. The one duty is that a pipeline's declared trigger stays equal to its globset's projection: the
**Native trigger globs** integrity gate (in `Test-Automation`, locally and in CI) fails any pipeline whose `paths:` filter has drifted from
`Get-GlobSetTrigger`. `Test-AdoPipelineTriggerGlob` and `Test-GitHubWorkflowTriggerGlob` show the per-pipeline status (Match/Drift/Missing)
without failing anything. Inside a CD pipeline, a unit's stage can stop early on a change that does not touch it:

```powershell
if (-not (Test-GlobSetAffected -Name my-unit)) { return }   # nothing here for us to process
```

`Test-GlobSetAffected` reflects the context's diff (post-commit first-parent, PR merge-base, or local working tree), fails open on any
doubt, and needs the pipeline checked out with `fetchDepth: 0` so the base commit is reachable.

## Protected scans (what the skip messages mean)

Repeated local gate runs skip the heavy repository scans (spelling, markdownlint) while their globset's durable SHA is unchanged since the
last green run in the session — you will see `Scan '<test>' skipped: globset '<name>' … unchanged`. That is the protected-glob gate
([protected-globs](../../../adr/automation/protected-globs.md)): session memory only, never active in CI, cleared by reloading the importer
or with `Clear-GlobSetProtection` when you want a full local rescan.
