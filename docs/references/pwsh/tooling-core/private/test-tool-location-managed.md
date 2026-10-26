# pwsh/Tooling.Core/private/Test-ToolLocationManaged.ps1

The private, subprocess-free check that a resolved tool location lies under a root of the installer layer. It is advisory, for the session
janitor `Sync-SessionTools`, and never a gate.

## help

### synopsis

Fast, subprocess-free check: does a resolved tool location belong to the installer layer?

### description

The session janitor (Sync-SessionTools) uses this to flag tools running from outside the directories the toolchain installs into. It is a
cheap PREFIX check by design — no `winget list`, no version probe — so it is safe to run for every tool on every import. It is advisory, not
authoritative: Get-ToolsStatus (which shells out to the package manager) stays the precise classifier. On Windows the user-scope roots it
trusts are both winget layouts (%LOCALAPPDATA%\Microsoft\WinGet\Packages for portable packages and %LOCALAPPDATA%\Programs for installer
packages such as OpenJDK) plus uv's standalone bin (%USERPROFILE%\.local\bin). An MSYS2-package tool (msys2_url) is owned on Windows inside
the tree it installs into (Get-ScriptInstallDir over its windows_install_dir), and wherever the system puts it elsewhere. Machine-scope /
Program Files installs, and npm/pip tools whose global bin sits outside the platform root, read as unmanaged here — an acceptable false
"foreign" for an advisory message, never a gate.

### parameter `Config`

The tool's ToolConfig (from Get-ToolConfig).

### parameter `Location`

The resolved on-disk path of the tool's command — (Get-Command `<command>).Source`.

## MSYS2 packages

MSYS2-package tools such as zsh live, on Windows, in the tree they install into: `windows_install_dir`, the Git for Windows tree
`Install-Git` provides. Elsewhere they are the system's, owned wherever the OS puts them.

## uv

uv-managed tools (az_cli, poetry) and uv-provisioned Python install their shims to uv's bin, `~/.local/bin` on every platform. Managed
Pythons and tool environments live in uv's data directory, `%APPDATA%\uv` (Roaming) on Windows and `~/.local/share/uv` on Unix, as
`uv tool dir` and `uv python dir` report, so a managed Python may also resolve there directly.

## Everything else

A tool is owned if its binary sits under the platform package manager's user-scope install root. npm and pip tools ride the platform
runtime, so they read as owned only when that runtime, and with it their global bin, is.

On Windows winget uses two user-scope layouts, and both count: portable packages (node, terraform) link under
`%LOCALAPPDATA%\Microsoft\WinGet\Packages`, while installer packages such as Microsoft.OpenJDK land under `%LOCALAPPDATA%\Programs`. Without
both roots a winget-managed JDK would read as foreign. `%USERPROFILE%\.local\bin` is the user bin uv installs itself into; `Install-Uv`
treats a uv there as a managed, self-updating install, and the janitor agrees rather than flagging it. Machine-scope Program Files installs
are deliberately left out: they read as foreign, the acceptable coarse-advisory case `Get-ToolsStatus` resolves authoritatively.
