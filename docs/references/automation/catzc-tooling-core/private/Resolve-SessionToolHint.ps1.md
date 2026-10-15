---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md
    kind: comment-page
    body_sha: "33886fec4d26"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Core/private/Resolve-SessionToolHint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
When a configured tool is not resolvable on PATH but tools.yml gives it session_path_hints (e.g. node's
nvm-for-windows symlink %ProgramFiles%\nodejs), this prepends the first hint directory that actually
contains the command to $env:PATH for THIS session only, then returns the resolved command. Session-only,
never persistent — the installer layer owns the registry PATH. Returns $null when the tool has no hints or
none resolve.
```

## comment:2

Above `$names = @($Config.command) +`.

```text
Does the command actually live in this dir? Probe the bare name plus the Windows executable
extensions (PATHEXT is empty on Unix, so only the bare name is probed there).
```

## comment:3

Above `$sep = [System.IO.Path]::PathSeparator`.

```text
Point THIS session at it by APPENDING the hint dir. The hint only fires when the command is otherwise
unresolvable, so nothing conflicts — and appending avoids a hint dir that also holds a python.exe (an
az uv-venv Scripts dir) shadowing the managed `python` on ~/.local/bin.
```

## comment:4

Above `return Get-Command $Config.command -CommandType Application -ErrorAction...`.

```text
-First 1: the command may now resolve in more than one PATH dir — an array's .Source would break the
[string] -Location binding downstream.
```
