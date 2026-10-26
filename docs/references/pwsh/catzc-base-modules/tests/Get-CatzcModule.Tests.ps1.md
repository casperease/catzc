# pwsh/Base.Modules/tests/Get-CatzcModule.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `shelves        = [ordered]@{ members = @('shelf'); type = 'shelf-works';...`, written with `#`.

```text
A third language's track, the shape every language track takes: folder modules, the track's own
test holder, a nested vendor track.
```

## comment:2

Above `$script:codeModules.name | Should -Be @($sorted | ForEach-Object {...`, written with `#`.

```text
Each folder resolves to its module's full name under the track's namespace
([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)).
```
