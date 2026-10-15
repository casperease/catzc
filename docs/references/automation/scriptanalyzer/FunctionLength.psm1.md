# automation/.scriptanalyzer/FunctionLength.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Counts lines from the opening brace to closing brace of the function body.
Comment-based help placed before the function (the project convention) is
naturally excluded. Functions longer than the limit are likely violating
single-responsibility.
```

## comment:2

Above `$isFunctionDefinition = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
