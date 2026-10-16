---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/tests/Assert-CatzcBundle.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6bf61ae741ff"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1

<!-- cspell:ignore nfunction -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:newFixtureBuild = {`, written with `#`.

```text
A hand-made, well-formed build of two neutral modules
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): widget is selected (its type
source
ships under Catzc.Base.Widget/types/), gadget's type source rides along under .compiled/types/ (every build
ships the full type set). typesHash comes from the one implementation, over the same two sources.
```

## comment:2

Above `$script:resealBuild = {`, written with `#`.

```text
Rewrites build.json after a fixture mutation, keeping the content hash current so only the mutated
property is under test.
```
