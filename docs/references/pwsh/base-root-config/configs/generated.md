# pwsh/Base.RootConfig/configs/generated.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `New-GitAttributes:`, written with `#`.

```text
Import-critical, since git reads .gitattributes at checkout; rootconfig.yml names its one target, which Build-RootConfig writes and
drift-checks, so the row carries its class and inputs and its output answers nothing of its own.
```
