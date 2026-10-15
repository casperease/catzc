---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/Import-CatzcOverlay.ps1.md
    kind: comment-page
    body_sha: "8f9dbf82ad51"
    adrs: []
---

# automation/Catzc.Base.Overlay/Import-CatzcOverlay.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs at the end of a bundle load ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). It checks
the overlay first (Assert-CatzcOverlay), so nothing applies unless all of it is valid. Then each override file
replaces its function inside the bundled module, in two steps:

  1. the file is dot-sourced inside the module's own scope (`. $module { . $file }`), so the module's callers,
     its script state and Mock -ModuleName reach the override (a call with & would open a child scope and
     discard the definition);
  2. a public override is published to the session's command table, where the import had put the original;
     its script block stays bound to the module, so it keeps running in the module's scope, and every other
     module, which resolves through the session, reaches the override too.

Then each local module loads, after the overrides so it calls the bundle as overridden: its private function
files, then its public ones (each ordinal — the order a built module's merge uses), are dot-sourced into one new
module of the folder's name, which exports the public ones. Nothing is written: the module is built in the
session, and its configs and assets are found in its overlay folder (Get-Config, Get-CatzcModuleRoot).

Config fragments and asset overrides need no step here: Get-Config and Get-CatzcModuleRoot read them on demand.
```
