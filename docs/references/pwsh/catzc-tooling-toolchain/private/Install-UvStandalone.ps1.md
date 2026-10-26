# pwsh/Tooling.Toolchain/private/Install-UvStandalone.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$digest = if ($asset.PSObject.Properties['digest']) {`, written with `#`.

```text
The GitHub release asset carries its published SHA-256 ('digest'); hard-fail rather than run an
unverified binary — the same discipline as Install-Git.
```

## comment:2

Above `$found = Get-ChildPath $extractDirectory -File -Filter $binary -Depth 3 |`, written with `#`.

```text
Select-Object -First 1 is $null on no match (indexing an empty array throws under strict), so the assert reports it
The archive holds the binaries one folder down; the third level is headroom.
```

## comment:3

Above `if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains...`, written with `#`.

```text
The uv tool-bin is normally on the persistent PATH already
([ADR-AUTO-UVPY](/docs/drs/automation/uv-python-handler.md)); make it resolve in this session.
```

## comment:4

Above `$release = $releases | Where-Object { ($_.tag_name -replace '^v', '') -match...`, written with `#`.

```text
Select-Object -First 1 is $null on no match (indexing an empty array throws under strict), so the assert reports
it
```

## comment:5

Above `$asset = $release.assets | Where-Object { $_.name -eq $assetName } |...`, written with `#`.

```text
Select-Object -First 1 is $null on no match (indexing an empty array throws under strict), so the assert reports
it
```
