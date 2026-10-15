---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/private/Get-LocalModuleViolation.ps1.md
    kind: comment-page
    body_sha: f8a4785b9838
    adrs: []
    links: []
---

# automation/Catzc.Base.Overlay/private/Get-LocalModuleViolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A local module is an overlay folder that names no bundled module, and it follows catzc's own module conventions
([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)): it never takes the reserved Catzc. prefix; it
carries no types/ (a bundle compiles no C#); it holds only function files at its root (public) and under
private/, and configs/, assets/ and tests/; every function file passes the shape check every function file
loaded away from its folder passes (Get-FunctionFileViolation); it has at least one function; and none of its
public functions takes the name of a command already loaded, which would silently replace a bundled one —
replacing a bundled function is an override, not a local module.
```
