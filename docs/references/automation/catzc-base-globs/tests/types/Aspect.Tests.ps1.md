---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md
    kind: test-asset
    body_sha: "0af8ad42b7bc"
---

# automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Aspect / AspectPartition' -Tag 'L0', 'logic' {`.

```text
Aspects ([ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)): the ordered first-match partition of a unit's tracked
files. Compile encodes each
aspect as a leaf scan program (own patterns as include, earlier aspects' patterns as exclude); the last
aspect ('**') becomes the non-live catch-all remainder. Validate re-checks disjoint + exhaustive.
```
