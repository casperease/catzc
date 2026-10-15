---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/Remove-VendorModules.ps1.md
    kind: comment-page
    body_sha: "7fd1dc073fb5"
    adrs: []
---

# automation/Catzc.Base.Vendor/Remove-VendorModules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Doubles as the "committed binaries are available on the network" check. For every targeted vendored module
it queries the configured source (configs/vendor.yml) for its committed version:

- Without -Force it changes nothing: it reports each target, whether the source can restore it, and the
  exact recreate command — a dry run.
- With -Force it deletes each target's automation/.vendor/<Name> folder, but only after confirming every
  target is restorable. If any is NOT available on the source, it refuses the whole run (deleting would be
  irreversible) — so a removal is always reversible, whether by Install-VendorModule or `git restore`.

A PR that strips vendored binaries (to slim the repo, leaning on the source) runs this to prove the set is
reproducible before deleting.

Deletes from the source tree's .vendor, so it stops with a named error in build mode (Assert-SourceTree,
[ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)) — an installed package's vendored modules are never removed by
it.
```
