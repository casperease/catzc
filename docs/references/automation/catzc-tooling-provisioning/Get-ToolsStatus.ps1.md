---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md
    kind: comment-page
    body_sha: "13bc06b6618c"
---

# automation/Catzc.Tooling.Provisioning/Get-ToolsStatus.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads tool definitions from configs/tools.yml and checks each tool's
presence, version, package manager, and install scope on the current
machine. Returns status objects for programmatic use and writes a summary.
Idempotent — safe to run at any time, read-only.
```

## comment:2

Above `$versionJobs = @{}`.

```text
Parallel version probes — each spawns a subprocess, so run them concurrently.
Only probe tools that are on PATH (missing tools skip the version check).
A tool with declared candidate paths is located by the probe instead (Test-Tool -PassThru, below): its bare
name on PATH may not be the tool at all (bash on Windows: the WSL launcher).
```

## comment:3

Above `$tokens =...`.

```text
Split the configured version-probe command line into executable + args with PowerShell's
tokenizer (it honours quoted arguments, e.g. pyspark's -c "import pyspark; ..."), so the
probe runs via the call operator instead of Invoke-Expression.
```

## comment:4

Above `if ($config.windows_only -and -not $IsWindows) {`.

```text
Windows-only tools (winget) do not exist elsewhere — skip them off Windows so they are not reported
as Missing on macOS/Linux.
```

## comment:5

Above `$expectedManager = if ($config.system_provided) {`.

```text
Mirror Test-ExpectedPackageManager check order:
SystemProvided → ScriptInstall → MSYS2 package (Windows) → uv → platform-specific → pip → npm → MSYS2
package elsewhere → unknown. An MSYS2 package installs on Windows only; on another platform the tool takes
the manager its entry declares there (apt_package on Linux), and with none it is the system's.
```

## comment:6

Above `$status = 'OK'`.

```text
Right version, right manager — scope doesn't matter. If winget
installed Python machine-wide, it works and we control it.
```

## comment:7

Above `$status = 'WrongVersion'`.

```text
Wrong version AND installed outside our manager. Installing via
$expectedManager would succeed but the existing binary on Machine PATH
would shadow it — the user would still run the old version.
```

## comment:8

Above `if ($IsWindows -and (Test-Command choco)) {`.

```text
Chocolatey check — not a tools.yml tool, but a package manager
that should not be present (see ADR: use-proper-package-managers).
Only report if actually found — no noise when absent.
```

## comment:9

Above `$versionJobs = @{}`.

```text
Parallel version probes — each spawns a subprocess, so run them concurrently.
Only probe tools that are on PATH (missing tools skip the version check).
A tool with declared candidate paths is located by the probe instead (Test-Tool -PassThru, below): its bare
name on PATH may not be the tool at all (bash on Windows: the WSL launcher).
```

## comment:10

Above `$tokens =...`.

```text
Split the configured version-probe command line into executable + args with PowerShell's
tokenizer (it honours quoted arguments, e.g. pyspark's -c "import pyspark; ..."), so the
probe runs via the call operator instead of Invoke-Expression.
```

## comment:11

Above `if ($config.windows_only -and -not $IsWindows) {`.

```text
Windows-only tools (winget) do not exist elsewhere — skip them off Windows so they are not reported
as Missing on macOS/Linux.
```

## comment:12

Above `$expectedManager = if ($config.system_provided) {`.

```text
Mirror Test-ExpectedPackageManager check order:
SystemProvided → ScriptInstall → MSYS2 package (Windows) → uv → platform-specific → pip → npm → MSYS2
package elsewhere → unknown. An MSYS2 package installs on Windows only; on another platform the tool takes
the manager its entry declares there (apt_package on Linux), and with none it is the system's.
```

## comment:13

Above `$status = 'OK'`.

```text
Right version, right manager — scope doesn't matter. If winget
installed Python machine-wide, it works and we control it.
```

## comment:14

Above `$status = 'WrongVersion'`.

```text
Wrong version AND installed outside our manager. Installing via
$expectedManager would succeed but the existing binary on Machine PATH
would shadow it — the user would still run the old version.
```

## comment:15

Above `if ($IsWindows -and (Test-Command choco)) {`.

```text
Chocolatey check — not a tools.yml tool, but a package manager
that should not be present (see ADR: use-proper-package-managers).
Only report if actually found — no noise when absent.
```
