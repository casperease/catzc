# pwsh/Base.FileLimits/private/Get-StringOverflowLine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$number = 0`, written with `#`.

```text
A JSON string never spans a line, so each line is scanned on its own: a quote opens, an escaped one does not close, and
outside a string a // comment (JSONC settings) ends the line.
```

## comment:2

Above `$spans = [System.Collections.Generic.List[int[]]]::new()`, written with `#`.

```text
The spans of every one-line string literal as (line, first column, last column), 1-based, from the language's own
tokenizer.
```

## comment:3

Above ``$sourceLines = $Text -split "`r?`n"``, written with `#`.

```text
The reader gives an attribute's line and the column of its name; the value runs from its opening quote to
the matching one.
```

## comment:4

Above ``$lines = $Text -split "`r?`n"``, written with `#`.

```text
A line is exempt when one string covers every column past the width to the end of its text, so nothing but the
string overflows.
```
