# pwsh/Base.Overlay/tests/Overlay.Fixture.ps1

The shared fixture of the overlay tests: a bundled module, a code root that ships it and a consumer overlay root.

## What it builds

The bundled module `Catzc.Base.Widget` is a real dynamic module in the session, so its functions and their contracts behave as bundled code
does without naming any real one. All names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). The
module has a public function `Get-Widget` and a private one `Get-WidgetCore`.

## How to use it

Dot-source it in `BeforeAll`; call `Remove-OverlayFixture` in `AfterAll`.
