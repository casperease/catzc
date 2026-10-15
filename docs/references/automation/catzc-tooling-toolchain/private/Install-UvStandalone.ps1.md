---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/private/Install-UvStandalone.ps1.md
    kind: comment-page
    body_sha: d542f91d7205
---

# automation/Catzc.Tooling.Toolchain/private/Install-UvStandalone.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Linux has no uv apt package, so the fresh-machine bootstrap is Astral's standalone release: resolve the
newest astral-sh/uv release matching the locked version prefix, download the platform tarball verified
against the release asset's published SHA-256 (Save-VerifiedDownload — the Install-Git discipline, see
[ADR-AUTO-PKGMGR](/docs/adr/automation/use-proper-package-managers.md)), and extract uv and uvx into the uv tool-bin
(~/.local/bin,
[ADR-AUTO-UVPY](/docs/adr/automation/uv-python-handler.md)). Entirely user-space: no package manager, no
elevation. The standalone build is also the one `uv self update` serves, so later upgrades stay in place.
```

## comment:2

Above `$digest = if ($asset.PSObject.Properties['digest']) {`.

```text
The GitHub release asset carries its published SHA-256 ('digest'); hard-fail rather than run an
unverified binary — the same discipline as Install-Git.
```

## comment:3

Above `if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains...`.

```text
The uv tool-bin is normally on the persistent PATH already
([ADR-AUTO-UVPY](/docs/adr/automation/uv-python-handler.md)); make it resolve in this session.
```

## comment:4

Above `$digest = if ($asset.PSObject.Properties['digest']) {`.

```text
The GitHub release asset carries its published SHA-256 ('digest'); hard-fail rather than run an
unverified binary — the same discipline as Install-Git.
```

## comment:5

Above `$found = Get-ChildPath $extractDirectory -File -Filter $binary -Depth 3 |`.

```text
Select-Object -First 1 is $null on no match (indexing an empty array throws under strict), so the assert reports it
The archive holds the binaries one folder down; the third level is headroom.
```

## comment:6

Above `if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains...`.

```text
The uv tool-bin is normally on the persistent PATH already
([ADR-AUTO-UVPY](/docs/adr/automation/uv-python-handler.md)); make it resolve in this session.
```
