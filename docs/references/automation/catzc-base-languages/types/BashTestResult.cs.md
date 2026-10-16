---
catzc:
  immutable:
    with_body_sha: bbf887422ab1
    repo_status: locked
    path: docs/references/automation/catzc-base-languages/types/BashTestResult.cs.md
    folder: docs/references/automation/catzc-base-languages/types
    name: bash-test-result-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#1
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Languages/types/BashTestResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One Bash test's result, as Invoke-BashTest returns it from the bats JUnit report: an `@test "<name>"` of a .bats file.
It has the shape of GoTestResult and PythonTestResult (Package, Name, Outcome, DurationSeconds, Output, Category), so
the harness maps every language's results the same way. A result type, so its properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

The category is derived here, the one place the rule lives: a test whose name starts with "integrity:" reads the
shipped artifacts and is `integrity`; every other test is `logic`
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)). Construction validates every
field and reports every violation in one ArgumentException.
```
