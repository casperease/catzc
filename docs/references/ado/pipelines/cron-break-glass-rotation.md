# .ado/pipelines/cron-break-glass-rotation.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `trigger: none`, written with `#`.

```text
CRON: rotates the production break-glass SQL password once a month, through the deploy service connection, which already holds the
rights the deploy uses on the server and the vault; nothing else runs it.
```
