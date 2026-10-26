# pwsh/Base.Overlay/tests/Import-CatzcOverlay.Tests.ps1

The tests of `Import-CatzcOverlay`: they apply a fixture overlay to a fixture bundle and check what was replaced and loaded.

## The fixture overlay

Config discovery and the content lookup reach the fixture overlay only through their own seams (`Get-ConfigOverlayRoot` is mocked), so the
test can never read a real consumer's overlay. The config index is rebuilt so it scans the fixture.
