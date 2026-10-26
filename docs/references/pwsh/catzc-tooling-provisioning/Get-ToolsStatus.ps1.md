# pwsh/Tooling.Provisioning/Get-ToolsStatus.ps1

The status report of the dev box: for every tool `tools.yml` registers it compares what is installed with what the lock requires and returns
one `ToolStatus` row per tool. It is read-only and the source of the verdicts that `Assert-DevBoxToolsStatus` and `Install-DevBoxTools` act
on.

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

## Probing versions

Each version probe spawns a subprocess, so the probes run concurrently, and only for tools that are on PATH. A tool with declared candidate
paths is located by the probe record (`Test-Tool -PassThru`) instead, because its bare name on PATH may not be the tool at all: `bash` on
Windows can be the WSL launcher. The configured probe command line is split into executable and arguments with PowerShell's tokenizer, which
honours quoted arguments such as PySpark's `-c "import pyspark; ..."`, so the probe runs through the call operator and never through
`Invoke-Expression`.

## Which tools are reported

A Windows-only tool such as winget is skipped off Windows, so it is not reported as Missing on macOS or Linux.

## The expected manager

The expected package manager follows the check order of `Test-ExpectedPackageManager`: system-provided, script install, MSYS2 package on
Windows, uv, the platform-specific manager, pip, npm, MSYS2 package elsewhere, then unknown. An MSYS2 package installs on Windows only; on
another platform the tool takes the manager its entry declares there (`apt_package` on Linux), and with none it is the system's.

## The verdict

- **OK** — the right version under the right manager; the scope does not matter, so a machine-wide winget install of Python works and is
  controlled.
- **WrongVersion**, installed outside the expected manager — installing through the expected manager would succeed, but the existing binary
  on the machine PATH would shadow it and the user would still run the old version.

## Chocolatey

Chocolatey is not a `tools.yml` tool but a package manager that should not be present
([ADR-AUTO-PKGMGR](../../../drs/automation/use-proper-package-managers.md)). It is reported only when actually found, so its absence makes
no noise.
