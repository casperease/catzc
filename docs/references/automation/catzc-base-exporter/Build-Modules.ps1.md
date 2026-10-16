---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md
    folder: docs/references/automation/catzc-base-exporter
    name: build-modules-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: abd4fae2272b
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.Exporter/Build-Modules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Build-Modules {`, written with `#`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:2

Above `Import-InternalModule Builder`, written with `#`.

```text
The engine is an .internal module, loaded on demand and not part of the post-import command set, so it is
invoked by name — which keeps it off the static function-dependency graph (the pattern the bootstrap
helpers use) while still resolving through normal command lookup.
```

## comment:3

Above `$isDeclaredBundle = -not ($PSBoundParameters.ContainsKey('Module') -or...`, written with `#`.

```text
The footprint limits describe the bundle as declared. A build whose selection or vendor policy is overridden
(an experiment, or a test build that adds the test toolset) is not that bundle, so it is not measured
against them.
```
