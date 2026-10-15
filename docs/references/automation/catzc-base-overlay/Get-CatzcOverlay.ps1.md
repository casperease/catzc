---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/Get-CatzcOverlay.ps1.md
    kind: comment-page
    body_sha: "82146efa590b"
    adrs: []
    links: []
---

# automation/Catzc.Base.Overlay/Get-CatzcOverlay.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Under .catzc/automation/ a file's location is its meaning: it sits at the path of what it changes in the
bundle's code root ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). A folder named for a bundled
module changes that module, and within it:

  <Function>.ps1          FunctionOverride (public)    replaces the module's public function <Function>
  private/<Function>.ps1  FunctionOverride (private)   replaces the module's private function <Function>
  configs/<config>.yml    ConfigFragment               merges onto the bundled config (Get-Config)
  assets/<path>           AssetOverride                replaces the bundled asset (Get-CatzcModuleRoot)
  tests/<path>            LocalTest                    a local test of the module as overridden
  anything else           Unknown                      not an override point (Assert-CatzcOverlay rejects it)

A folder that names no bundled module is a LocalModule. Nothing is loaded or checked here; the inventory is
what Assert-CatzcOverlay checks and Import-CatzcOverlay applies, and what a reader asks to see what a session
changed. Returns nothing when there is no overlay (source mode, or no .catzc/automation/).
```
