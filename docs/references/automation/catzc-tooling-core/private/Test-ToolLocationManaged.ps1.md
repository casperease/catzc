---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md
    folder: docs/references/automation/catzc-tooling-core/private
    name: test-tool-location-managed-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "1dd29ba69af6"
---

# automation/Catzc.Tooling.Core/private/Test-ToolLocationManaged.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($Config.msys2_url) {`, written with `#`.

```text
MSYS2-package tools (zsh) live, on Windows, in the tree they install into (windows_install_dir, the Git for Windows
tree Install-Git provides); elsewhere they are the system's, owned wherever the OS puts them.
```

## comment:2

Above `if ($Config.uv_tool -or $Config.uv_python) {`, written with `#`.

```text
uv-managed tools (az_cli, poetry) and uv-provisioned python install their shims to uv's bin
(~/.local/bin cross-platform); managed pythons may also resolve to uv's data dir directly.
```

## comment:3

Above `$uvRoots = if ($IsWindows) {`, written with `#`.

```text
uv's shims go to ~/.local/bin; its managed pythons/tool-envs live in the data dir — %APPDATA%\uv
(Roaming) on Windows, ~/.local/share/uv on Unix (verified via `uv tool dir` / `uv python dir`).
```

## comment:4

Above `$roots = if ($IsWindows) {`, written with `#`.

```text
Otherwise: owned iff the binary sits under the platform package manager's user-scope install root. npm/pip
tools ride the platform runtime, so they read as owned only when that runtime (and thus their global bin)
is. On Windows winget uses two distinct user-scope layouts, and both are ours: PORTABLE packages (node,
terraform) link under %LOCALAPPDATA%\Microsoft\WinGet\Packages, while INSTALLER packages (e.g.
Microsoft.OpenJDK) land under %LOCALAPPDATA%\Programs — so both roots must count, or a winget-managed JDK
reads as foreign. %USERPROFILE%\.local\bin is the standalone/user bin uv installs itself into: Install-Uv
treats a uv there (outside the winget root) as a managed, self-updating install, so the janitor agrees
rather than flagging it. Machine-scope Program Files installs are deliberately NOT here — they read as
foreign, the acceptable coarse-advisory case Get-ToolsStatus resolves authoritatively.
```
