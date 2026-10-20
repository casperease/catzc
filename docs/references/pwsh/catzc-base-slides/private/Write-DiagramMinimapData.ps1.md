# pwsh/Catzc.Base.Slides/private/Write-DiagramMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$maps = Get-Config -Config maps`, written with `#`.

```text
Each declared folder's three minimaps, computed from its ADR codes by the data command maps.yml names per id, written as
out/minimaps/<folder>/<id>.json beside minimaps.json, the ids in order; the kit's put draws from them and computes nothing.
```
