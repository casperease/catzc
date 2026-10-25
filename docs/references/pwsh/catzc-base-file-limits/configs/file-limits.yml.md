# pwsh/Catzc.Base.FileLimits/configs/file-limits.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `bounds: { length: { min: 100, max: 500 }, width: { min: 80, max: 200 } }`, written with `#`.

```text
Every key is optional: an omitted key takes the default declared once on FileLimitsConfig. A language value wins over its class default,
and no value may leave the bounds; a value outside them fails the config load.
```
