# automation/Catzc.Tooling.Core/Sync-SessionTools.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reconciles the current session's PATH to the tools that are actually present, and reports any running from outside the installer layer.
Registered as a post-import janitor.

### description

A lightweight, quiet-on-clean pass over the tools.yml set. For each tool it:

- re-resolves it in the session (after a Sync-SessionPath to recover dropped registry entries), and
- when the tool is unresolvable but declares session_path_hints (e.g. nvm-managed node), prepends the hinted directory to $env:PATH so THIS
  session can still run it, and
- when the tool declares session_host_probes and more than one install exists, moves the best one to the front of $env:PATH so THIS session
  runs it (Resolve-SessionToolHost) — for dotnet an SDK at the locked version first, else a runtime at the locked version. The other
  installs are left in place.

Every present tool whose location is not owned by the installer layer (Test-ToolLocationManaged) is collected and reported on two lines: the
advisory (the fact plus which tools) on the always-on information stream, and each tool's resolved location — diagnostic detail — on the
verbose stream, so a plain import names the offenders and -Verbose adds the paths. The pass emits nothing when every present tool is
installer-owned. Session-only — it never writes the registry — and a no-op in CI, where the pipeline provisions tools. Advisory, not a gate:
Get-ToolsStatus stays the authoritative, subprocess-backed classifier. Its outcome is remembered per machine (out/cache/session-tools.json)
under the key of the tool registry and the PATH it started from: a session that starts from the same PATH gets the PATH the pass left and
the same advisory without probing a tool again, and a changed registry or PATH runs the pass anew.

### parameter Silent

Suppress both advisory lines outright (even under -Verbose).

### example 1

```powershell
Sync-SessionTools
```

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

## comment:4

Above `$memoPath = Join-Path (Get-OutputRoot) 'cache/session-tools.json'`, written with `#`.

```text
The pass probes every tool on disk, so its outcome is remembered per machine under the key of what it read: the tool registry
and the session's PATH as it stood. The same key gets the same outcome, the PATH the pass left, re-applied without a probe.
```
