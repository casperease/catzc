---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/tests/Overlay.Fixture.ps1.md
    kind: test-asset
    body_sha: "304d68e6cdce"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Overlay/tests/Overlay.Fixture.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:fixtureRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))`.

```text
Shared fixture of the overlay tests: a bundled module Catzc.Base.Widget (a dynamic module in the session, so its
functions and their contracts are real), a code root that ships it, and a consumer overlay root — all neutral
names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)). Dot-source it in BeforeAll;
call Remove-OverlayFixture in AfterAll.
```
