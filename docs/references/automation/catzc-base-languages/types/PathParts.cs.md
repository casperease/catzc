---
catzc:
  immutable:
    with_body_sha: "9f949d1122ac"
    repo_status: locked
    path: docs/references/automation/catzc-base-languages/types/PathParts.cs.md
    folder: docs/references/automation/catzc-base-languages/types
    name: path-parts-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-FILEMETA#11
---

# automation/Catzc.Base.Languages/types/PathParts.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class PathParts`, written with `//`.

```text
[ADR-REPO-FILEMETA#11](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta11): a path under its module is an optional folder, a
kebab-case name and a file type, and only that.
```

## comment:2

Above `public static PathParts Of(string tail)`, written with `//`.

```text
Splits a '/' or '\' separated path under its module (the whole path for a file in no module) and asserts that the three parts
build the path back: the folders, the name and the file type, compared as kebab case.
```
