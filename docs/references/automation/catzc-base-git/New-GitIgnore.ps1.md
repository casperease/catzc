---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/New-GitIgnore.ps1.md
    kind: comment-page
    body_sha: "636a69381902"
---

# automation/Catzc.Base.Git/New-GitIgnore.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the section registry (configs/gitignore.yml, via Get-Config -Config gitignore) and renders it to the
full .gitignore text: each section as a titled comment
block with its wrapped `why` explanation and its verbatim pattern lines (Format-GitIgnoreSection). A
section declaring `inject: <provider>` takes its patterns from -Inject at render time — the root-config
section is fed the registry's committed:false targets by Build-RootConfig, so the ignored-copies list
lives in ONE place (rootconfig.yml) and .gitignore can never drift from it.

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
root-config registry names for the .gitignore target, and Build-RootConfig owns the write (through the
same idempotent Write-FileIfChanged path as every managed file). It reads only its own registry, never
rootconfig.yml, so Catzc.Base.Git carries no dependency on Catzc.Base.RootConfig (the composition edge
runs the other way; see [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
```

## comment:2

Section `.PARAMETER Inject` of the comment-based help.

```text
Render-time patterns per provider name (e.g. @{ 'rootconfig-committed-false' = '/.editorconfig', … }).
Every `inject` provider the registry names must be supplied — an unknown provider throws; an empty list
renders the section titled but empty.
```

## comment:3

Above `$patterns = if ($section.inject) {`.

```text
Resolve the section's patterns: static from the registry, or injected by the caller. An inject
provider the caller did not supply is a wiring defect — fail loudly, never render a silently
incomplete .gitignore.
```

## comment:4

Above `$patterns = if ($section.inject) {`.

```text
Resolve the section's patterns: static from the registry, or injected by the caller. An inject
provider the caller did not supply is a wiring defect — fail loudly, never render a silently
incomplete .gitignore.
```
