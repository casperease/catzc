---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Test-GlobSetIndependence.ps1.md
    kind: comment-page
    body_sha: f22626a5ce7c
    adrs:
      - ADR-FLOW-CD-GLOBS#{7,10}
---

# automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$exemptLayer = 'loose-fileset'`, written with `#`.

```text
loose-filesets are cross-cutting and overlap-exempt
([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)/10); every other layer is
checked.
```

## comment:2

Above `$own = @{}`, written with `#`.

```text
OWN members per set (compose ignored,
[ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)), computed once as a set for
O(1) intersection.
```
