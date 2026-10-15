---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
    kind: test-asset
    body_sha: cc7e3cff6079
    adrs:
      - ADR-FLOW-CD-GLOBS#10
---

# automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'GlobSet independence' -Tag 'L2', 'integrity', 'source-only' {`.

```text
Integrity: per-layer independence
([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)) holds in the REAL repository —
within every non-loose
layer, no two globsets (declared or derived) select a common file on their OWN contribution. The
'loose-fileset' layer is exempt: its sets are cross-cutting check surfaces (a track's root concern, a scan
scope, the reserved umbrellas) and overlap by design. A module or deployable-unit that starts containing
part of a peer — a mis-scoped include, an umbrella mis-declared as a module — fails here, locally and in
CI. L2 because the tracked-file universe comes from the real git CLI.
```
