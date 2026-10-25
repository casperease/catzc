# pwsh/Catzc.Base.FileLimits/types/FileLimitsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public ResolvedFileLimit ResolveFile(string path, string language)`, written with `//`.

```text
An override is applied before the language lookup, an exact file name first, then the extension; it takes its class's defaults, never the
language's own values. A file no override and no language declares fails, so nothing tracked escapes unlimited.
```
