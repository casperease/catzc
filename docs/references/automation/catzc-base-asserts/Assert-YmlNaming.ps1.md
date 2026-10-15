---
catzc:
  derived:
    path: docs/references/automation/catzc-base-asserts/Assert-YmlNaming.ps1.md
    kind: comment-page
    body_sha: f9a2d866b867
    adrs: []
---

# automation/Catzc.Base.Asserts/Assert-YmlNaming.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Recursively walks a parsed YAML structure and asserts that every property key
matches snake_case (lowercase letters, digits, underscores, starting with a letter).
List items and values are not checked.
```

## comment:2

Section `.PARAMETER PropertyPath` of the comment-based help.

```text
Optional root prefix for error messages. Useful when validating a subtree,
e.g. Assert-YmlNaming $config.customers 'customers' will report paths as
'customers.blue.details' instead of 'blue.details'.
```
