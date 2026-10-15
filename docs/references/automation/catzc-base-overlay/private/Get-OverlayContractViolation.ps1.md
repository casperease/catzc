---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/private/Get-OverlayContractViolation.ps1.md
    kind: comment-page
    body_sha: a28c670765aa
    adrs: []
    links: []
---

# automation/Catzc.Base.Overlay/private/Get-OverlayContractViolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The bundle's own code keeps calling a function the way it always has, so an override keeps the original's
contract ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)): it declares every parameter the
original declares, with the same type; it adds no mandatory parameter the original does not have as mandatory;
and it declares the same [OutputType]. Read from the override's syntax tree, against the loaded original.
```
