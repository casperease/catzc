---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Sync-SessionTools.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d97fcc2d48b2
---

# automation/Catzc.Tooling.Core/Sync-SessionTools.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (Test-IsRunningInPipeline) {`, written with `#`.

```text
Session PATH nudging is noise — and could shadow image-provided tools — in CI, where the pipeline owns
tool provisioning. Do nothing there.
```

## comment:2

Above `$hosted = Resolve-SessionToolHost -Config $config`, written with `#`.

```text
When several installs exist, run the best one (tools.yml session_host_probes — for dotnet an SDK at the
locked version, else a runtime at the locked version). The other installs are left in place.
```

## comment:3

Above `Write-Message "Session tools not managed by the installer layer:...`, written with `#`.

```text
The fact and WHICH tools is the advisory — it stays on the always-on information stream. Each tool's
resolved location is diagnostic detail, so the second line carries the paths on the verbose stream and
surfaces only under -Verbose (forward THIS call's verbose state, so a plain import shows just the names
and `Sync-SessionTools -Verbose` adds the locations).
```
