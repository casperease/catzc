# pwsh/Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1

The L0 tests of `Assert-CatzcBundle`: each guard is pinned on its own against a hand-made build in `TestDrive:`.

## Fixtures

The fixture is a hand-made, well-formed build of two neutral modules
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). The widget module is
selected, so its type source ships under `Catzc.Base.Widget/types/`; the gadget module's type source rides along under `.compiled/types/`,
since every build ships the full type set. The types hash comes from the one implementation, over the same two sources.

After a fixture mutation `build.json` is rewritten with the content hash kept current, so only the mutated property is under test.
