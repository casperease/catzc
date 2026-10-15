---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md
    kind: comment-page
    body_sha: "6cf682e6b37a"
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.Exporter/Build-Modules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:9

Above `function Build-Modules {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:10

Above `Import-InternalModule Builder`.

```text
The engine is an .internal module, loaded on demand and not part of the post-import command set, so it is
invoked by name — which keeps it off the static function-dependency graph (the pattern the bootstrap
helpers use) while still resolving through normal command lookup.
```

## comment:11

Above `$isDeclaredBundle = -not ($PSBoundParameters.ContainsKey('Module') -or...`.

```text
The footprint limits describe the bundle as declared. A build whose selection or vendor policy is overridden
(an experiment, or a test build that adds the test toolset) is not that bundle, so it is not measured
against them.
```
