# pwsh/Base.QualityGates/private/Set-CSharpFileScopedNamespace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the C# source with a file-scoped `namespace <Namespace>;` line present and correct.

### description

The string engine behind Format-Types. Pure (text in, text out), so it is unit-tested directly.

- When the source already declares a file-scoped namespace, its name is corrected to `<Namespace>` (a no-op when it already matches).
- When it declares none, `namespace <Namespace>;` is inserted after the leading comment/using block — before the first type or attribute —
  padded by a blank line on each side.
- A block-scoped `namespace X { … }` (not a shape this repo authors) is left untouched, so the helper never double-declares; Format-Types
  reports it and Test-Formatting turns it into an issue.

Line endings are normalised to LF and a single trailing newline is preserved (repo convention).

### parameter `Content`

The C# source text.

### parameter `Namespace`

The module namespace the file must declare (its `<Module>` folder).

### outputs

`[string]` The source with the namespace line in place.

## comment:1

Above `for ($i = 0; $i -lt $lines.Count; $i++) {`, written with `#`.

```text
An existing namespace declaration: correct a file-scoped one in place (no-op when already right);
leave a block-scoped one (file-scoped lines end with ';'; anything else is a block) untouched — not a
shape we author, so Format-Types reports it rather than this helper double-declaring.
```
