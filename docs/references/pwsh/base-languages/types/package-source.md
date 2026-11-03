# pwsh/Base.Languages/types/PackageSource.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public static PackageSource Read(object value, PackageSource fallback,...`, written with `//`.

```text
The source a config declares under package_source, else the language's fallback; a key left out takes the fallback's own.
A url is https unless the fallback's own is the registry-host form; each violation is added to errors.
```
