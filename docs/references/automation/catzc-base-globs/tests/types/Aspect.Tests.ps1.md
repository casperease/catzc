---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: df9202a23048
---

# automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Aspect / AspectPartition' -Tag 'L0', 'logic' {`, written with `#`.

```text
Aspects ([ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)): the ordered first-match partition of a unit's tracked
files. Compile encodes each
aspect as a leaf scan program (own patterns as include, earlier aspects' patterns as exclude); the last
aspect ('**') becomes the non-live catch-all remainder. Validate re-checks disjoint + exhaustive.
```
