---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/Assert-CatzcOverlay.ps1.md
    kind: comment-page
    body_sha: b5c6fdf6dc8b
    adrs: []
---

# automation/Catzc.Base.Overlay/Assert-CatzcOverlay.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The overlay is the only place a consumer changes what a built bundle does, so it is checked as a whole before
any of it is applied ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)):

  Unknown           an entry that is no override point
  FunctionOverride  one function named for the file, loadable anywhere (Get-FunctionFileViolation); it replaces
                    a function the bundled module has, with the same visibility (a public override replaces an
                    exported function, a private one a function the module keeps to itself); it keeps the
                    original's contract (every parameter, with its type; no new mandatory parameter; the same
                    [OutputType]). A new function belongs in a local module.
  ConfigFragment    merges onto a config the module ships, and never onto a sealed one (configs.yml
                    overridable: false)
  AssetOverride     replaces an asset the module ships; a new asset belongs in a local module
  LocalModule       follows catzc's module conventions (Get-LocalModuleViolation): never the reserved Catzc.
                    prefix, no types/, only function files, configs/, assets/ and tests/, every function file
                    well-shaped, and no public function that takes the name of a command already loaded.

A consumer's CI runs it on its own to fail early; Import-CatzcOverlay runs it before it applies anything.
```
