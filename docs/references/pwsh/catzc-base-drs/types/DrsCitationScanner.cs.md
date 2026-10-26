# pwsh/Base.Drs/types/DrsCitationScanner.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public string[] Citations(string text, bool withDomain)`, written with `//`.

```text
The registered codes a text cites, minimized: a rule the text defines is no citation, and a domain code counts only where the
file's class takes domain codes.
```
