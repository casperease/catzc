# pwsh/Base.VSCode/tests/TrackLamps.Tests.ps1

The tests of the `catzc-track-lamps` extension from the PowerShell side: the shared vectors of the lamp language, the rendered manifest and
the extension folder.

## Where the cases run

The engine-core cases run in node, in `js/track-lamps/tests/` (`Invoke-JavaScriptTest`); the shared vectors stay here, read from YAML. The
disk is walked once, and each lamp's census reads the verdict its plan reached, as the live engine does
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).

## What is covered

Aspects belong to units, so only a unit's tests count; vendored code is no unit, and its test folders are tools. Every tagged language of
the languages config is a lamp of its own, `lang-<name>`, with a lamp's commands, rendered icons and menu items.

The extension's folder is resolved from its name through the js track
([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
