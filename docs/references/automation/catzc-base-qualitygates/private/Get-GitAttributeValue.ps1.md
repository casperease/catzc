---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-GitAttributeValue.ps1.md
    kind: comment-page
    body_sha: bcac126f1473
---

# automation/Catzc.Base.QualityGates/private/Get-GitAttributeValue.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one place the scopes of the quality gates ask git which file classes .gitattributes declares (vendored,
generated, fixture, own title), so every scope reads the same classes the same way. Runs `git check-attr` in
batches that keep each command line short; a path need not be tracked. Only attributes git reports as set,
unset, or a value are returned — `unspecified` is left out. A root that is not a git work tree has no
.gitattributes, so nothing is returned for it.
```
