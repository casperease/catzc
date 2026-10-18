---
catzc:
  immutable:
    with_body_sha: be8fda485660
    repo_status: locked
    path: docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md
    folder: docs/references/automation/catzc-tooling-core/private
    name: resolve-session-tool-hint-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Core/private/Resolve-SessionToolHint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Points the current session at a tool installed outside the installer layer, using its declared hints.

### description

When a configured tool is not resolvable on PATH but tools.yml gives it session_path_hints (e.g. node's nvm-for-windows symlink
%ProgramFiles%\nodejs), this prepends the first hint directory that actually contains the command to
$env:PATH for THIS session only, then returns the resolved command. Session-only,
never persistent — the installer layer owns the registry PATH. Returns $null
when the tool has no hints or none resolve.

### parameter Config

The tool's ToolConfig (from Get-ToolConfig).

## comment:1

Above `$names = @($Config.command) +`, written with `#`.

```text
Does the command actually live in this dir? Probe the bare name plus the Windows executable
extensions (PATHEXT is empty on Unix, so only the bare name is probed there).
```

## comment:2

Above `$sep = [System.IO.Path]::PathSeparator`, written with `#`.

```text
Point THIS session at it by APPENDING the hint dir. The hint only fires when the command is otherwise
unresolvable, so nothing conflicts — and appending avoids a hint dir that also holds a python.exe (an
az uv-venv Scripts dir) shadowing the managed `python` on ~/.local/bin.
```

## comment:3

Above `return Get-Command $Config.command -CommandType Application -ErrorAction...`, written with `#`.

```text
-First 1: the command may now resolve in more than one PATH dir — an array's .Source would break the
[string] -Location binding downstream.
```
