# pwsh/Catzc.Base.Docs/Add-SessionLearning.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above ``$parts = $text.Split('`')``, written with `#`.

```text
Wrapped as the markdown formatter wraps a list item (prettier, printWidth 140), so formatting never rewrites the log.
A '<' outside a code span would read as inline HTML to the lint (MD033), so it is escaped there.
```
