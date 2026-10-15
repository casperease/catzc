---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
    kind: comment-page
    body_sha: "6e82457794b1"
    adrs:
      - ADR-FLOW-CD-GLOBS#10
      - ADR-FLOW-CD-GLOBS#7
---

# automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$exemptLayer = 'loose-fileset'`.

```text
loose-filesets are cross-cutting and overlap-exempt
([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)/10); every other layer is
checked.
```

## comment:5

Above `$own = @{}`.

```text
OWN members per set (compose ignored,
[ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)), computed once as a set for
O(1) intersection.
```
