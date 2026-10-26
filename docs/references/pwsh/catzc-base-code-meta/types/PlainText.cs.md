# pwsh/Base.CodeMeta/types/PlainText.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class PlainText`, written with `//`.

```text
A comment page's synopsis and its plain-text projection: the one sentence a contract's description holds, with every link, rule code,
code span and markup stripped, and the form a YAML plain scalar takes without quoting.
```

## comment:2

Above `public static string Plain(string text)`, written with `//`.

```text
The text with links reduced to their words, rule codes and the brackets they leave empty removed, code spans and emphasis unmarked,
and every run of white space one space.
```

## comment:3

Above `public static string PlainScalarFinding(string text)`, written with `//`.

```text
Why the text is no plain description: one line of letters, digits, spaces and . , - ( ) ' only, so a YAML plain scalar holds it as
written; null when it is one.
```
