---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Sync-SessionTools.ps1.md
    kind: comment-page
    body_sha: "046355a166ce"
    adrs: []
---

# automation/Catzc.Tooling.Core/Sync-SessionTools.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A lightweight, quiet-on-clean pass over the tools.yml set. For each tool it:
  - re-resolves it in the session (after a Sync-SessionPath to recover dropped registry entries), and
  - when the tool is unresolvable but declares session_path_hints (e.g. nvm-managed node), prepends the
    hinted directory to $env:PATH so THIS session can still run it, and
  - when the tool declares session_host_probes and more than one install exists, moves the best one to the
    front of $env:PATH so THIS session runs it (Resolve-SessionToolHost) — for dotnet an SDK at the locked
    version first, else a runtime at the locked version. The other installs are left in place.
Every present tool whose location is not owned by the installer layer (Test-ToolLocationManaged) is
collected and reported on two lines: the advisory (the fact plus which tools) on the always-on information
stream, and each tool's resolved location — diagnostic detail — on the verbose stream, so a plain import
names the offenders and -Verbose adds the paths. The pass emits nothing when every present tool is
installer-owned. Session-only — it never writes the registry — and a no-op in CI, where the pipeline
provisions tools. Advisory, not a gate: Get-ToolsStatus stays the authoritative, subprocess-backed
classifier.
```

## comment:2

Above `if (Test-IsRunningInPipeline) {`.

```text
Session PATH nudging is noise — and could shadow image-provided tools — in CI, where the pipeline owns
tool provisioning. Do nothing there.
```

## comment:3

Above `$hosted = Resolve-SessionToolHost -Config $config`.

```text
When several installs exist, run the best one (tools.yml session_host_probes — for dotnet an SDK at the
locked version, else a runtime at the locked version). The other installs are left in place.
```

## comment:4

Above `Write-Message "Session tools not managed by the installer layer:...`.

```text
The fact and WHICH tools is the advisory — it stays on the always-on information stream. Each tool's
resolved location is diagnostic detail, so the second line carries the paths on the verbose stream and
surfaces only under -Verbose (forward THIS call's verbose state, so a plain import shows just the names
and `Sync-SessionTools -Verbose` adds the locations).
```
