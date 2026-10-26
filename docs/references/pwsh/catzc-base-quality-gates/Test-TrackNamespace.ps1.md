# pwsh/Base.QualityGates/Test-TrackNamespace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$tracked = @(Get-GitTrackedPath '.')`, written with `#`.

```text
A folder or file under a track drops the namespace its track declares; only a file the track exempts keeps it
([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)).
```
