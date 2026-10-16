---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-GlobSetTrigger.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4e57cea0beba"
    adrs:
      - ADR-FLOW-CD-GLOBS#1
---

# automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlobSetTrigger' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-GlobSetTrigger: project a globset's scan program into vendor-native path filters
([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)) — GitHub
ordered '!'-negation paths (exact), ADO order-independent include/exclude (last-select-per-pattern).
```

## comment:2

Above `$script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{`, written with `#`.

```text
A base drops configuration/*/**; a unit re-adds its own configuration/widget/** on top. GitHub keeps
the ordered program (last match wins); ADO collapses each pattern to its last select — so the re-add
is an include and the broader drop stays an exclude, no contradictory pattern. Composition is built
through GlobsConfig (the real path — ResolveCompose is internal).
```

## comment:3

Above `$script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{` (occurrence 2), written with `#`.

```text
The 'shared'-shaped case: base excludes configuration/*.yml, the unit re-adds the identical pattern.
Last select wins -> the pattern is an ADO include only, never both include and exclude.
```
