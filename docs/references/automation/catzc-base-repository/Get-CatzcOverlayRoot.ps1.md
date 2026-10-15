---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/Get-CatzcOverlayRoot.ps1.md
    kind: reference
    body_sha: "5c848caffe5e"
    adrs: []
---

# automation/Catzc.Base.Repository/Get-CatzcOverlayRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A consumer of a built bundle works in its own working root and changes what the bundle does only through its
overlay, the .catzc/ folder there ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). Under
.catzc/automation/ every file sits at the path of what it changes in the bundle's code root, so this root is
where a config fragment, a function override, a local module, or a local test is looked for.

The overlay applies in build mode only. In source mode the catzc tree is automation/ itself and is changed
there directly, so the function returns nothing even when a .catzc/ folder exists; it also returns nothing
when the working root has no .catzc/automation/. It is derived, never stored, like the run mode: it cannot
disagree with what loaded.
```
