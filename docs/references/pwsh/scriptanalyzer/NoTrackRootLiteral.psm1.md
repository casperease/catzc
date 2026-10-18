# pwsh/.scriptanalyzer/NoTrackRootLiteral.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:roots = $null`, written with `#`.

```text
The modules track's places and the exempt globs, read once per analyzer session
([ADR-AUTO-LAYERS](/docs/adr/automation/layers.md)).
```
