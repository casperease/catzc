---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/tests/Set-FileLink.Tests.ps1.md
    kind: test-asset
    body_sha: "189cfd17ad3d"
    adrs:
      - ADR-AUTO-RETRY#1
---

# automation/Catzc.Base.Files/tests/Set-FileLink.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$probeSource = Join-Path $TestDrive 'probe-source.txt'`.

```text
Capability probe: symbolic links need a privilege on Windows (Developer Mode / admin); hard links do
not. The assertions branch on the probe — deterministic per machine, never a retry
([ADR-AUTO-RETRY#1](/docs/adr/automation/retry-as-last-resort.md#rule-adr-auto-retry1)).
```

## comment:2

Above `New-Item -ItemType HardLink -Path $script:linkPath -Target $script:sourcePath...`.

```text
A hard link (created directly — no privilege needed) goes stale when the source is replaced by a
new file (what git checkout/pull does): the old bytes stay behind under the link.
```
