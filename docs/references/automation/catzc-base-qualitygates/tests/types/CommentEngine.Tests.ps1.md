---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/CommentEngine.Tests.ps1.md
    kind: test-asset
    body_sha: "0d69e450011e"
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
---

# automation/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1

<!-- cspell:ignore nwidgets npublic nvar nwidget ngadget gadgt wdgt -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'CommentEngine' -Tag 'L0', 'logic' {`.

```text
deliberate misspelling a kept cspell directive covers
CommentEngine moves a file's long comments to its comment page and back, losslessly
([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)): what moves is decided by
comments.yml ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)). Each case
runs the engine over a short widget/gadget snippet; the proofs are the round trip and the idempotent second run.
```
