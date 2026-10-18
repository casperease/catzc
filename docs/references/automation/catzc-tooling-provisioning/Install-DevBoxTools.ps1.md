---
catzc:
  immutable:
    with_body_sha: "169dd915e433"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-provisioning/Install-DevBoxTools.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning
    name: install-dev-box-tools-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Provisioning/Install-DevBoxTools.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Provisions the local development environment with all required tools.

### description

Installs all locked tool versions in dependency order (derived from DependsOn in tools.yml). Idempotent — safe to run repeatedly. Skips
tools that are already installed at the correct version. Tools at the correct version but installed outside the expected manager are left
untouched with a message.

### parameter Force

Replace existing installations that are at the wrong version.

### example 1

```powershell
Install-DevBoxTools
```

### example 2

```powershell
Install-DevBoxTools -Force
```

## comment:1

Above `Uninstall-Chocolatey`, written with `#`.

```text
Remove Chocolatey if present — this toolset uses winget on Windows.
See ADR: use-proper-package-managers.
```

## comment:2

Above `Install-Git -Force:$Force`, written with `#`.

```text
Git first: a base tool (not version-locked, not in tools.yml) that the locked set builds on — on Windows its
Git Bash is the platform-provided `bash` asserted below.
```

## comment:3

Above `if ($config.system_provided) {`, written with `#`.

```text
Platform-provided tools (winget; bash — the OS's, or Git Bash on Windows) are never installed — assert
present (Test-Tool: winget by name, kept on PATH by its session_path_hints; bash at its candidate paths)
and move on, so the tools that depend on them fail fast if absent.
```

## comment:4

Above `if ((Test-ToolRequiresElevation $config) -and -not (Test-IsAdministrator)) {`, written with `#`.

```text
Elevation-bound tools (admin_only machine-scope installers, or apt-get-routed Linux installs —
Test-ToolRequiresElevation) cannot install without elevation. Skip and report in a non-elevated run
rather than failing the whole provision; re-run elevated to get them.
```

## comment:5

Above `if ($config.depends_on -and $skipped.Contains([string] $config.depends_on)) {`, written with `#`.

```text
A tool whose declared dependency was skipped this run — and whose dependency's command is not
available from an earlier install either — cannot install. Skip and report it with the same
remediation instead of letting its installer fail the whole provision.
```
