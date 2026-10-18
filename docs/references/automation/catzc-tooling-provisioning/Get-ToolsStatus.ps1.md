---
catzc:
  immutable:
    with_body_sha: "8a2d0a4c5c4b"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning
    name: get-tools-status-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Provisioning/Get-ToolsStatus.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reports the installation status of all registered tools.

### description

Reads tool definitions from configs/tools.yml and checks each tool's presence, version, package manager, and install scope on the current
machine. Returns status objects for programmatic use and writes a summary. Idempotent — safe to run at any time, read-only.

### example 1

```powershell
Get-ToolsStatus
```

### example 2

```powershell
Get-ToolsStatus | Where-Object Status -ne 'OK'
```

## comment:1

Above `$versionJobs = @{}`, written with `#`.

```text
Parallel version probes — each spawns a subprocess, so run them concurrently.
Only probe tools that are on PATH (missing tools skip the version check).
A tool with declared candidate paths is located by the probe instead (Test-Tool -PassThru, below): its bare
name on PATH may not be the tool at all (bash on Windows: the WSL launcher).
```

## comment:2

Above `$tokens =...`, written with `#`.

```text
Split the configured version-probe command line into executable + args with PowerShell's
tokenizer (it honours quoted arguments, e.g. pyspark's -c "import pyspark; ..."), so the
probe runs via the call operator instead of Invoke-Expression.
```

## comment:3

Above `if ($config.windows_only -and -not $IsWindows) {`, written with `#`.

```text
Windows-only tools (winget) do not exist elsewhere — skip them off Windows so they are not reported
as Missing on macOS/Linux.
```

## comment:4

Above `$expectedManager = if ($config.system_provided) {`, written with `#`.

```text
Mirror Test-ExpectedPackageManager check order:
SystemProvided → ScriptInstall → MSYS2 package (Windows) → uv → platform-specific → pip → npm → MSYS2
package elsewhere → unknown. An MSYS2 package installs on Windows only; on another platform the tool takes
the manager its entry declares there (apt_package on Linux), and with none it is the system's.
```

## comment:5

Above `$status = 'OK'`, written with `#`.

```text
Right version, right manager — scope doesn't matter. If winget
installed Python machine-wide, it works and we control it.
```

## comment:6

Above `$status = 'WrongVersion'` (occurrence 2), written with `#`.

```text
Wrong version AND installed outside our manager. Installing via
$expectedManager would succeed but the existing binary on Machine PATH
would shadow it — the user would still run the old version.
```

## comment:7

Above `if ($IsWindows -and (Test-Command choco)) {`, written with `#`.

```text
Chocolatey check — not a tools.yml tool, but a package manager
that should not be present (see ADR: use-proper-package-managers).
Only report if actually found — no noise when absent.
```
