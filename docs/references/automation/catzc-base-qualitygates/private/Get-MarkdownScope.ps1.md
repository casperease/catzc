---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownScope.ps1.md
    kind: comment-page
    body_sha: "8d9415449eaa"
---

# automation/Catzc.Base.QualityGates/private/Get-MarkdownScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every git-tracked *.md file — the repository as committed, so a gitignored generated README is never in scope while
its tracked source is — minus the files the content tools leave as written (Get-ContentExemptPath: vendored,
generated, fixture, or contract asset) and those whose OptOut attribute .gitattributes marks unset (the meta block's
-catzc-meta; the title has none). No list of its own: a new exception is declared in the .gitattributes source
like every other file class.
```

## comment:2

Above `$exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $markdown`.

```text
Every class comes from .gitattributes.
Get-ContentExemptPath returns its paths as one array: assign it, so the set holds the paths, not the array.
```

## comment:3

Above `$exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $markdown`.

```text
Every class comes from .gitattributes.
Get-ContentExemptPath returns its paths as one array: assign it, so the set holds the paths, not the array.
```
