---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/Test-CompletesWithin.ps1.md
    kind: reference
    body_sha: a10d3d8cc634
    adrs: []
---

# automation/Catzc.Base.Timeouts/Test-CompletesWithin.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The boolean form of Assert-CompletesWithin: $true when the block finished in time, $false when the safeguard
stopped it at the limit. The block's output is discarded. An error the block raises on its own is not a
timeout, so it still throws — this answers "was it fast enough", never "did it succeed".
```

## comment:2

Section `.PARAMETER Budget` of the comment-based help.

```text
The work's immutable budget GUID. While timeout-exemptions.yml exempts it, the default limit is the exemption
ceiling instead.
```

## comment:3

Section `.PARAMETER Seconds` of the comment-based help.

```text
The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption
ceiling (Get-TimeoutSeconds -Budget).
```
