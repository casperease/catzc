# pwsh/Tooling.Provisioning/Install-Git.ps1

The installer of Git, the base tool the locked set builds on. On Windows it unpacks PortableGit into the user's tree, elsewhere it uses the
platform package manager.

## help

### synopsis

Installs Git (user-space on Windows, package manager elsewhere).

### description

Windows: Downloads the latest PortableGit from git-scm.com (GitHub releases) and extracts to LOCALAPPDATA\Git. No admin required. Persists
PATH for future sessions. macOS: brew install git. Linux: apt-get install git (requires root). Idempotent — skips if already installed.

### parameter `Force`

Remove an existing installation before reinstalling.

### example 1

```powershell
Install-Git
```

### example 2

```powershell
Install-Git -Force
```

## Verifying the download

Git is a sanctioned latest-version base tool, so there is no committed hash to pin
([ADR-AUTO-DEPS-LOCKEDTOOLVERSIONS](../../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-lockedtoolversions)). Every Git for Windows release publishes a per-asset SHA-256
through the GitHub API, the `digest` of the asset. The download is verified against it, and the command fails hard if the digest is ever
absent, rather than run an unverified installer.

## Extracting

The PortableGit `.7z.exe` is a self-extracting archive: `-o` sets the output directory and `-y` suppresses prompts.

## Idempotent first

The idempotent guard comes first, as on macOS. A box that already has git, for example because it cloned this repository, must never trip the
root assert on Linux just to conclude there is nothing to do.
