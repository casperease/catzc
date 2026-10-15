---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Resolve-SessionToolHint.Tests.ps1.md
    kind: test-asset
    body_sha: aff6790a2f6d
---

# automation/Catzc.Tooling.Core/tests/Resolve-SessionToolHint.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
Fixture uses a .cmd shim + PATHEXT resolution — a Windows shape. The Unix path is analogous.
Set-ItResult is legal only per-test, so the non-Windows skip lives in BeforeEach, not BeforeAll —
calling it in BeforeAll throws and fails the whole Describe off-Windows. Capture origPath first so
AfterEach restores PATH even on the skipped path.
```
