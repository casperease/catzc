# pwsh/Catzc.Base.Languages/New-JsConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$config = if ($Target -eq 'jsconfig.strict.json') {`, written with `#`.

```text
The strict project extends the lenient one and checks only the raised modules; the lenient one leaves them out, so each file is
checked once, in its module's mode (tsc has no per-folder strict).
```
