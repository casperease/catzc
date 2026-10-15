---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Install-Git.ps1.md
    kind: comment-page
    body_sha: e76df4a846f5
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Provisioning/Install-Git.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Windows: Downloads the latest PortableGit from git-scm.com (GitHub
releases) and extracts to LOCALAPPDATA\Git. No admin required.
Persists PATH for future sessions.
macOS: brew install git.
Linux: apt-get install git (requires root).
Idempotent — skips if already installed.
```

## comment:2

Above `$digest = if ($asset.PSObject.Properties['digest']) {`.

```text
git is a sanctioned 'latest' base tool, so there is no committed hash to pin — but every Git for
Windows release publishes a per-asset SHA-256 via the GitHub API ('digest'). Verify the download
against it, and hard-fail if it is ever absent rather than run an unverified installer. See ADR
controlling-systemwide-deps.
```

## comment:3

Above `Write-Message "Extracting to '$installDir'"`.

```text
PortableGit .7z.exe is a self-extracting archive. The -o flag sets
the output directory and -y suppresses prompts.
```

## comment:4

Above `if ((Test-Command git) -and -not $Force) {`.

```text
Idempotent guard first (as on macOS) — a box that already has git (e.g. it cloned this repo) must
never trip the root assert below just to conclude there is nothing to do.
```
