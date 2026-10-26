# pwsh/Tooling.Core/tests/Resolve-SessionToolHint.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
Fixture uses a .cmd shim + PATHEXT resolution — a Windows shape. The Unix path is analogous.
Set-ItResult is legal only per-test, so the non-Windows skip lives in BeforeEach, not BeforeAll —
calling it in BeforeAll throws and fails the whole Describe off-Windows. Capture origPath first so
AfterEach restores PATH even on the skipped path.
```
