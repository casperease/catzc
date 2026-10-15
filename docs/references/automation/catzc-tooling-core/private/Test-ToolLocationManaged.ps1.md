# docs/references/automation/catzc-tooling-core/private/Test-ToolLocationManaged.ps1.md

`automation/Catzc.Tooling.Core/private/Test-ToolLocationManaged.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The session janitor (Sync-SessionTools) uses this to flag tools running from outside the directories the
toolchain installs into. It is a cheap PREFIX check by design — no `winget list`, no version probe — so it
is safe to run for every tool on every import. It is advisory, not authoritative: Get-ToolsStatus (which
shells out to the package manager) stays the precise classifier. On Windows the user-scope roots it trusts
are both winget layouts (%LOCALAPPDATA%\Microsoft\WinGet\Packages for portable packages and
%LOCALAPPDATA%\Programs for installer packages such as OpenJDK) plus uv's standalone bin
(%USERPROFILE%\.local\bin). An MSYS2-package tool (msys2_url) is owned on Windows inside the tree it installs into
(Get-ScriptInstallDir over its windows_install_dir), and wherever the system puts it elsewhere. Machine-scope / Program Files installs, and npm/pip tools whose global bin sits
outside the platform root, read as unmanaged here — an acceptable false "foreign" for an advisory message,
never a gate.
```

## comment:2

Above `if ($Config.msys2_url) {`.

```text
MSYS2-package tools (zsh) live, on Windows, in the tree they install into (windows_install_dir, the Git for Windows
tree Install-Git provides); elsewhere they are the system's, owned wherever the OS puts them.
```

## comment:3

Above `if ($Config.uv_tool -or $Config.uv_python) {`.

```text
uv-managed tools (az_cli, poetry) and uv-provisioned python install their shims to uv's bin
(~/.local/bin cross-platform); managed pythons may also resolve to uv's data dir directly.
```

## comment:4

Above `$uvRoots = if ($IsWindows) {`.

```text
uv's shims go to ~/.local/bin; its managed pythons/tool-envs live in the data dir — %APPDATA%\uv
(Roaming) on Windows, ~/.local/share/uv on Unix (verified via `uv tool dir` / `uv python dir`).
```

## comment:5

Above `$roots = if ($IsWindows) {`.

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
