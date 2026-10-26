# pwsh/Tooling.Toolchain/private/Install-UvStandalone.ps1

A private helper of `Install-Uv`: the Linux bootstrap and upgrade of uv from Astral's standalone release.

## help

### synopsis

Bootstraps uv on Linux from Astral's standalone GitHub release — user-space, hash-verified, no root.

### description

Linux has no uv apt package, so the fresh-machine bootstrap is Astral's standalone release: resolve the newest astral-sh/uv release matching
the locked version prefix, download the platform tarball verified against the release asset's published SHA-256 (Save-VerifiedDownload — the
Install-Git discipline, see [ADR-AUTO-PKGMGR](../../../../drs/automation/use-proper-package-managers.md)), and extract uv and uvx into the
uv tool-bin (~/.local/bin, [ADR-AUTO-UVPY](../../../../drs/automation/uv-python-handler.md)). Entirely user-space: no package manager, no
elevation. The standalone build is also the one `uv self update` serves, so later upgrades stay in place.

### parameter `Version`

The locked uv version prefix from tools.yml (e.g. '0.11').

## Verification

The GitHub release asset carries its published SHA-256, the `digest`. The command fails hard rather than run an unverified binary, the same
discipline as `Install-Git`.

## Finding the pieces

The release and the asset are picked with `Select-Object -First 1`, which yields `$null` on no match, since indexing an empty array throws
under strict mode; the assert after it reports the miss. The archive holds the binaries one folder down, and the search goes three levels
deep for headroom.

## PATH

The uv tool-bin is normally on the persistent PATH already
([ADR-AUTO-UVPY](../../../../drs/automation/uv-python-handler.md)); the command makes it resolve in the current session too.
