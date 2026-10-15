---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/CommentFindingKind.cs.md
    kind: reference
    body_sha: "4b3d89593227"
    adrs:
      - ADR-PRIN-ONELIVE#1
---

# automation/Catzc.Base.QualityGates/types/CommentFindingKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.QualityGates;`.

```text
What CommentFormatter found at one residue of a file, or at one comment that still lives there. A residue is the
one living copy of a comment's insight: one line that says what the code does not, then a line with its ADR
citations and the docs link ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)).
The fixable kinds are rewritten by Format-Comments and reported by Test-Comments until they are; the rest cannot
be fixed mechanically and need a person, or Export-Comments.
```
