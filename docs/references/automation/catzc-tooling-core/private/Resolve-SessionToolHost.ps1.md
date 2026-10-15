---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHost.ps1.md
    kind: comment-page
    body_sha: "04c054303c69"
    adrs: []
---

# automation/Catzc.Tooling.Core/private/Resolve-SessionToolHost.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Some tools can be installed more than once on one machine, and the first one on PATH is not always usable —
on Windows a machine-wide, runtime-only C:\Program Files\dotnet precedes the user PATH and shadows the
managed SDK. When tools.yml gives the tool `session_host_probes`, this considers every candidate home in
order — the installer layer's own home first (Get-ScriptInstallDir, for a script-installed tool), then the
directory of every PATH match — and takes the FIRST probe that ANY home satisfies (Test-ToolHomeProbe): for
dotnet an SDK at the locked version, else a runtime at the locked version. The chosen home moves to the
front of $env:PATH for THIS session only, announced on the information stream because it changes what the
session runs. No other install is removed and the registry PATH is never written. Returns the resolved
command, or $null when the tool declares no probes or no home satisfies any of them (PATH is then left
exactly as it was). Filesystem checks only — no process is started.
```

## comment:2

Above `Get-Command $Config.command -CommandType Application -ErrorAction Ignore |...`.

```text
-First 1: the command may still resolve in more than one PATH dir — an array's .Source would break the
[string] -Location binding downstream.
```
