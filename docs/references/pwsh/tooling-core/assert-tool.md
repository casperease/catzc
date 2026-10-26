# pwsh/Tooling.Core/Assert-Tool.ps1

The runtime guard for one tool of `tools.yml`: it throws unless the tool is installed at the locked version.

## help

### synopsis

Asserts that a tool is installed and at the expected version.

### description

Checks that the tool's command is on PATH and that its version matches the locked version in tools.yml (outside a CI pipeline an optional
devbox_version lever also passes — see Assert-ToolVersion). Does NOT check DependsOn — those are install-time dependencies, not runtime
requirements. A tool whose entry declares candidate paths is located by the executable probe instead (Resolve-ToolExecutable): its
candidates for this platform and run environment, then PATH.

### parameter `Tool`

The snake_case tool key as defined in tools.yml (e.g., 'python', 'az_cli').

### parameter `SkipVersionCheck`

Only assert the tool is on PATH. Skip the version match. Use for operations that need presence but not a specific version (e.g.,
uninstalling).

### example 1

```powershell
Assert-Tool 'python'
```

### example 2

```powershell
Assert-Tool 'poetry'
```

## Locating the tool

A tool with declared candidate paths is located by the probe, never by its bare name on PATH, because for bash on Windows that name can be
the WSL launcher.
