---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Install-Git.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "94d6ec65ac3b"
---

# automation/Catzc.Tooling.Provisioning/Install-Git.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$digest = if ($asset.PSObject.Properties['digest']) {`, written with `#`.

```text
git is a sanctioned 'latest' base tool, so there is no committed hash to pin — but every Git for
Windows release publishes a per-asset SHA-256 via the GitHub API ('digest'). Verify the download
against it, and hard-fail if it is ever absent rather than run an unverified installer. See ADR
controlling-systemwide-deps.
```

## comment:2

Above `Write-Message "Extracting to '$installDir'"`, written with `#`.

```text
PortableGit .7z.exe is a self-extracting archive. The -o flag sets
the output directory and -y suppresses prompts.
```

## comment:3

Above `if ((Test-Command git) -and -not $Force) {`, written with `#`.

```text
Idempotent guard first (as on macOS) — a box that already has git (e.g. it cloned this repo) must
never trip the root assert below just to conclude there is nothing to do.
```
