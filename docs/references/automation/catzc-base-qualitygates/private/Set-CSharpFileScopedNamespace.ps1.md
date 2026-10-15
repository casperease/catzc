---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Set-CSharpFileScopedNamespace.ps1.md
    kind: comment-page
    body_sha: bf01a548ba66
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Set-CSharpFileScopedNamespace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The string engine behind Format-Types. Pure (text in, text out), so it is unit-tested directly.

  - When the source already declares a file-scoped namespace, its name is corrected to <Namespace>
    (a no-op when it already matches).
  - When it declares none, `namespace <Namespace>;` is inserted after the leading comment/using block —
    before the first type or attribute — padded by a blank line on each side.
  - A block-scoped `namespace X { … }` (not a shape this repo authors) is left untouched, so the helper
    never double-declares; Format-Types reports it and Test-Formatting turns it into an issue.

Line endings are normalised to LF and a single trailing newline is preserved (repo convention).
```

## comment:2

Above `for ($i = 0; $i -lt $lines.Count; $i++) {`.

```text
An existing namespace declaration: correct a file-scoped one in place (no-op when already right);
leave a block-scoped one (file-scoped lines end with ';'; anything else is a block) untouched — not a
shape we author, so Format-Types reports it rather than this helper double-declaring.
```
