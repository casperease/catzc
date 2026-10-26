# pwsh/Tooling.Toolchain/Install-Uv.ps1

The installer and upgrader of uv, Astral's Python handler, which most other tools of the toolchain install through.

## help

### synopsis

Installs or upgrades uv, Astral's Python handler.

### description

uv is user-space on every platform. A fresh machine bootstraps it via winget on Windows and brew on macOS (both hash-verified, user-scope,
no admin), and from Astral's standalone GitHub release on Linux (Install-UvStandalone — verified download into ~/.local/bin; there is no uv
apt package). An already-present uv is upgraded through its install source: Linux re-runs the standalone install (Install-UvStandalone — the
extracted tarball carries no `uv self update` receipt), macOS re-runs brew and a winget-managed uv re-runs winget (both via Install-Tool);
only a Windows uv installed by Astral's own script (receipt-backed) upgrades with `uv self update`. Idempotent — skips if the correct
version is already on PATH.

### parameter `Version`

uv version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Upgrade even when a build is already present.

## A fresh machine

The bootstrap depends on the platform: winget on Windows and brew on macOS, both through `Install-Tool`, and Astral's standalone release on
Linux, in user space under `~/.local/bin`, since there is no uv apt package.

## Upgrading

An upgrade goes through the configured install source, not through a blanket `uv self update`. The Linux bootstrap extracts the standalone
tarball into `~/.local/bin`, which leaves no self-update receipt, and winget and brew manage their own packages, so `uv self update` refuses
all three ("installed via pip/brew/another package manager"). Re-asserting the configured install upgrades in place:

- **Linux** — the pinned, verified standalone build is downloaded again over `~/.local/bin`, which also replaces an off-config uv, such as a
  leftover pip-installed one, that happens to sit in the tool-bin.
- **Windows** — a winget-managed uv upgrades through winget; a uv installed by Astral's own script, on PATH outside the winget package root,
  carries a self-update receipt and upgrades in place.
