---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/TestTitle-TemplateTokens.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "2a66d46a65f0"
    adrs:
      - ADR-AUTO-TEST#{25,35}
---

# automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test titles use angle-bracket templates only on data-driven tests'...`, written with `#`.

```text
Poka-yoke backstop: no <token>-shaped text in a non-data-driven test title, over the real tree through its quality
gate (Test-TestTitles — [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).

Pester treats <word> in an It/Describe/Context title as its name-template syntax; WITHOUT -ForEach/-TestCases data
the token is almost always prose and THROWS under the strict tests
([ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)) at name expansion, far from the
cause. The gate bans the pattern outright: a title with a <token> must carry -ForEach data.
(These titles themselves spell out "angle-bracket token" — a literal one here would fire the very trap.)
source-only: it parses the repository's test files, which give the same answer in both run modes.
```
