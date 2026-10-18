# pwsh/Catzc.Base.QualityGates/types/FunctionHelp.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static string Markdown(string text)`, written with `//`.

```text
Plain help text written inside YAML, as Markdown that means the same: lists at the margin, aligned layouts fenced verbatim, and a
placeholder, glob or bracket token in a code span, so a formatter or a linter reads what the author wrote.
```
