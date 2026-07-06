# Add a deployable unit (a globset and its sha-marker)

A deployable unit is defined exactly once, as a **globset** in `automation/Catzc.Base.Globs/configs/globs.yml` — a named set of glob
patterns over the files under version control. The unit's identity is its **durable SHA**, persisted with the set's canonical definition in
a committed sha-marker file `.sha-markers/<name>.yml`; pipelines and workflows path-filter on that one file and never on source paths. The
full model is the [durable-sha-globs](../../../adr/pipelines/durable-sha-globs.md) ADR; this page is the workflow.

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
`git ls-files`. The config is strictly validated on load — an unknown key, a malformed pattern, or a set matching a sha-marker file is
rejected with a named error.

Inspect the result before committing to it:

```powershell
Get-GlobSet -Name my-unit          # the compiled set + its MarkerPath
Get-GlobSetFile -Name my-unit      # exactly the files the identity is computed over
Get-GlobSetHash -Name my-unit      # the durable SHA itself
```

## Generate and commit the sha-marker

Nothing to do on a dev box: every import syncs the marker files and auto-commits them (the `Sync-GeneratedFile` janitor — pathspec-limited,
so only `.sha-markers/` and `automation/.compiled/` land in the stamp commit; opt out with `-NoCommitShaMarkersInDevBox`). To run the sync
by hand:

```powershell
Update-ShaMarker                   # writes .sha-markers/my-unit.yml (and refreshes any other stale set)
```

`Update-ShaMarker` is idempotent, writes only on change, and removes the marker file of any globset that no longer exists.

## Register the consumers

Point every pipeline or workflow that should fire for this unit at the sha-marker file — and at nothing else:

- **ADO root pipeline** — `trigger:`/`pr:` `paths: include: [.sha-markers/my-unit.sha256]`.
- **GitHub workflow** — `on.push.paths` / `on.pull_request.paths: [.sha-markers/my-unit.sha256]`.
- **ADO build-validation policy** (server-side) — set the policy's path filter to `/.sha-markers/my-unit.sha256`.

The exact YAML shapes are in the ADR's
[registration section](../../../adr/pipelines/durable-sha-globs.md#registering-a-pipeline-or-workflow).

## The daily discipline

A commit that changes any file a globset matches must also carry the regenerated sha-marker file. On a dev box the importer's janitor keeps
this true by itself; forgetting is safe either way: the **Marker freshness** integrity gate (in `Test-Automation`, locally and in CI) fails
on any stale, missing, or orphaned marker file and its message tells you to run `Update-ShaMarker`. `Test-ShaMarker` shows the per-set
status (Fresh/Stale/Missing/Orphaned) without failing anything.

## Protected scans (what the skip messages mean)

Repeated local gate runs skip the heavy repository scans (spelling, markdownlint) while their globset's durable SHA is unchanged since the
last green run in the session — you will see `Scan '<test>' skipped: globset '<name>' … unchanged`. That is the protected-glob gate
([protected-globs](../../../adr/automation/protected-globs.md)): session memory only, never active in CI, cleared by reloading the importer
or with `Clear-GlobSetProtection` when you want a full local rescan.
