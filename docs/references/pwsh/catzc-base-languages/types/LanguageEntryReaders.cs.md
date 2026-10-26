# pwsh/Base.Languages/types/LanguageEntryReaders.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `internal static List<LayoutRow> ReadLayout(string name, List<string>...`, written with `//`.

```text
A language's layout rows: { folder, role, extensions, live, shipped }. A row at the module root ('.') lists the extensions it places,
all among the language's own; any other row places every file in its folder. live and shipped default to true, the default every
language row takes; only the shared tests row differs, and it is declared on LayoutRow.
```

## comment:2

Above `internal static LanguageTestRunner ReadTests(string name, object value,...`, written with `//`.

```text
A language's test runner: a runner command, the parameter its executable binds to, and either the tools that must resolve or the
one engine the tests run under, never both and never neither.
```
