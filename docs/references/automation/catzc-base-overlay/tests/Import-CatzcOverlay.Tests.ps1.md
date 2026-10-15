---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/tests/Import-CatzcOverlay.Tests.ps1.md
    kind: test-asset
    body_sha: "9b9630ce2b2b"
---

# automation/Catzc.Base.Overlay/tests/Import-CatzcOverlay.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith {...`.

```text
Config discovery and the content lookup reach the fixture overlay through their own seams; the config
index is rebuilt so it scans the fixture.
```
