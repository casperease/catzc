---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/private/Install-UvStandalone.ps1.md
    kind: comment-page
    body_sha: "3c98c881fcbb"
---

# automation/Catzc.Tooling.Toolchain/private/Install-UvStandalone.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

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
