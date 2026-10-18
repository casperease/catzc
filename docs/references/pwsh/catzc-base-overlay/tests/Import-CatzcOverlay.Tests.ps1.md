# pwsh/Catzc.Base.Overlay/tests/Import-CatzcOverlay.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-ConfigOverlayRoot -ModuleName Catzc.Base.Config -MockWith {...`, written with `#`.

```text
Config discovery and the content lookup reach the fixture overlay through their own seams; the config
index is rebuilt so it scans the fixture.
```
