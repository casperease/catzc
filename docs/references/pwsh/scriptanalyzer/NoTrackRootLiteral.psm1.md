# pwsh/.scriptanalyzer/NoTrackRootLiteral.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:roots = $null`, written with `#`.

```text
The modules track's places and the exempt globs, read once per analyzer session
([ADR-AUTO-LAYERS](/docs/drs/automation/layers.md)).
```

## comment:2

Above `$script:roots = @(foreach ($track in $variants['tracks'].Values) {`, written with `#`.

```text
The relocatable modules root (Get-CatzcModulesRoot) holds the track whose modules run under this engine, pwsh; its
places are the ones no string may spell.
```

## comment:3

Above `$parent = $node.Parent`, written with `#`.

```text
The bare place is also a word with other senses (an ADR domain, a layer), so alone it counts only where a path
is built.
```

## comment:4

Above `. (Join-Path $modulesRoot '.internal/assets/bootstrap/Resolve-ModuleName.ps1')`, written with `#`.

```text
Module folders resolve from their full names under the track's namespace, read before any import
([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)).
```
