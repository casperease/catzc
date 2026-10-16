---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Set-CSharpFileScopedNamespace.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ac985da13429
---

# automation/Catzc.Base.QualityGates/private/Set-CSharpFileScopedNamespace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `for ($i = 0; $i -lt $lines.Count; $i++) {`, written with `#`.

```text
An existing namespace declaration: correct a file-scoped one in place (no-op when already right);
leave a block-scoped one (file-scoped lines end with ';'; anything else is a block) untouched — not a
shape we author, so Format-Types reports it rather than this helper double-declaring.
```
