# pwsh/Base.Languages/types/JavaScriptConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public const string DefaultTypesFolder = ".typescript";`, written with `//`.

```text
The repository-relative, gitignored folder the tooling installs the type declarations into (npm --prefix), so the generated
jsconfig.json names the same relative type root on every machine.
```
