---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Comments.ps1.md
    kind: comment-page
    body_sha: "4d1ca533db76"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
    links: []
---

# automation/Catzc.Base.QualityGates/Test-Comments.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the files in
scope (Get-CommentScope). A file carries one residue per long comment and the prose lives once, in the file's
comment page ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)); it lists
every issue:

- a comment long enough to move that is still in the file (run Export-Comments);
- a residue that links a page other than the file's own;
- a residue whose section the page does not hold, so its prose is lost from the view;
- a residue number the file uses twice;
- a page section no residue in the file links, so its prose belongs to nothing.

What the configured thresholds are is comments.yml's
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)). The shape of the
insight line is Format-Comments' to fix, not this gate's. A source-tree tool: it throws in build mode
(Assert-SourceTree).
```
