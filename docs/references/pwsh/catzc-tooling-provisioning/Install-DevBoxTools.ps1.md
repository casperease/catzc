# pwsh/Tooling.Provisioning/Install-DevBoxTools.ps1

The provisioner of the whole dev box: it runs a fixed sequence of base steps, then installs every locked tool in dependency order, each
through that tool's own `Install-*` command.

## help

### synopsis

Provisions the local development environment with all required tools.

### description

Installs all locked tool versions in dependency order (derived from DependsOn in tools.yml). Idempotent — safe to run repeatedly. Skips
tools that are already installed at the correct version. Tools at the correct version but installed outside the expected manager are left
untouched with a message.

### parameter `Force`

Replace existing installations that are at the wrong version.

### example 1

```powershell
Install-DevBoxTools
```

### example 2

```powershell
Install-DevBoxTools -Force
```

## The sequence

1. Chocolatey is removed if present, since this toolset uses winget on Windows.
2. Git comes first: a base tool that is not version-locked and not in `tools.yml`, which the locked set builds on. On Windows its Git Bash is
   the platform-provided `bash` asserted below.
3. The locked tools follow in dependency order.

## Platform-provided tools

Platform-provided tools (winget, and `bash` as the OS's own or Git Bash on Windows) are never installed. They are asserted present, winget by
name and kept on PATH by its `session_path_hints`, `bash` at its candidate paths, and the run moves on, so the tools that depend on them fail
fast if they are absent.

## Skipped tools

An elevation-bound tool (an `admin_only` machine-scope installer, or an apt-get-routed Linux install, per `Test-ToolRequiresElevation`)
cannot install without elevation. A non-elevated run skips it and reports it rather than failing the whole provision; a re-run elevated gets
it. A tool whose declared dependency was skipped this run, and whose dependency's command is not available from an earlier install either,
is skipped and reported the same way, instead of letting its installer fail the whole provision.
