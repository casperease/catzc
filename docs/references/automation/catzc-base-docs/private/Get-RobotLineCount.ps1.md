# automation/Catzc.Base.Docs/private/Get-RobotLineCount.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$front = @($document.OtherFrontMatter | Where-Object { $_ -cmatch '^\S' }).Count`, written with `#`.

```text
A line counts when it starts something of its own: a key, a heading, a step, a paragraph. A line that starts with
whitespace continues the line before it (the formatter's wrap at the repository width, or a folded YAML value) and
counts with it; a blank line and a comment line (`<!-- -->`) count as nothing.
```
