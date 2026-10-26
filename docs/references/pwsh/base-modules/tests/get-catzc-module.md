# pwsh/Base.Modules/tests/Get-CatzcModule.Tests.ps1

The L0 tests of `Get-CatzcModule`: they resolve neutral tracks laid out in `TestDrive:`.

## Fixtures

One fixture track stands for a third language's track, the shape every language track takes: folder modules, the track's own test holder and
a nested vendor track. The tests check that the vendor track's files, a dot folder's cache and the test holder are not a folder module's
files, and that each folder resolves to its module's full name under the track's namespace
([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
