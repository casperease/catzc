---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/GoTestResult.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6fdcf2867642"
    adrs:
      - ADR-AUTO-TEST#1
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Languages/types/GoTestResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One Go test's result, as Invoke-GoTest returns it from the `go test -json` event stream: a top-level test
function of a package, with its subtests folded into it (their output joins the parent's, and go itself fails
the parent when a subtest fails). A result type, so its properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

The category is derived here, the one place the rule lives: a test named TestIntegrity* reads the shipped
artifacts and is `integrity`; every other test is `logic`
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)). Construction validates every
field and reports every violation in one ArgumentException.
```
