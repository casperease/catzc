---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Sync-SessionTools.ps1.md
    kind: comment-page
    body_sha: "115d3a378d8d"
---

# automation/Catzc.Tooling.Core/Sync-SessionTools.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `if (Test-IsRunningInPipeline) {`.

```text
Session PATH nudging is noise — and could shadow image-provided tools — in CI, where the pipeline owns
tool provisioning. Do nothing there.
```

## comment:6

Above `$hosted = Resolve-SessionToolHost -Config $config`.

```text
When several installs exist, run the best one (tools.yml session_host_probes — for dotnet an SDK at the
locked version, else a runtime at the locked version). The other installs are left in place.
```

## comment:7

Above `Write-Message "Session tools not managed by the installer layer:...`.

```text
The fact and WHICH tools is the advisory — it stays on the always-on information stream. Each tool's
resolved location is diagnostic detail, so the second line carries the paths on the verbose stream and
surfaces only under -Verbose (forward THIS call's verbose state, so a plain import shows just the names
and `Sync-SessionTools -Verbose` adds the locations).
```
