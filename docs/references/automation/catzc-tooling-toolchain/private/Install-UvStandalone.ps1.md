---
catzc:
  immutable:
    with_body_sha: "6be38f691799"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-toolchain/private/Install-UvStandalone.ps1.md
    folder: docs/references/automation/catzc-tooling-toolchain/private
    name: install-uv-standalone-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Toolchain/private/Install-UvStandalone.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
([ADR-AUTO-UVPY](/docs/adr/automation/uv-python-handler.md)); make it resolve in this session.
```
