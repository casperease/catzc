# pwsh/Catzc.Base.Overlay/tests/Overlay.Fixture.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:fixtureRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))`, written with `#`.

```text
Shared fixture of the overlay tests: a bundled module Catzc.Base.Widget (a dynamic module in the session, so its
functions and their contracts are real), a code root that ships it, and a consumer overlay root — all neutral
names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). Dot-source it in BeforeAll;
call Remove-OverlayFixture in AfterAll.
```

## comment:2

Above `function Get-Widget {`, written with `#`.

```text
.SYNOPSIS
    The fixture module's public function.
```

## comment:3

Above `function Get-WidgetCore {`, written with `#`.

```text
.SYNOPSIS
    The fixture module's private function.
```
