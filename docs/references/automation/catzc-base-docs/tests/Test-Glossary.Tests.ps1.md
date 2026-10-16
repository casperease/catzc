---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: abb8735bc8ea
    adrs:
      - ADR-AUTO-TEST#{19,20}
---

# automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-Glossary' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-Glossary orchestrates the six checks; here every check and the glossary readers are mocked, so the tests pin
the order, the report, the PassThru shape, and the single aggregate throw
([ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)). The checks
themselves are covered by their own L0 files; the real-tree run is the L2 integrity block at the end of this file.
```

## comment:2

Above `Describe 'Test-Glossary — real glossary sources' -Tag 'L2', 'integrity',...`, written with `#`.

```text
The real glossary sources against the real ADRs, tests, and tracked files. G1 and G4 reach git (the tracked-file
listing), so this is L2; the answer is the same in both run modes, so the build run skips it. Test-Glossary runs
once over the real sources and every It reads its part of that one result
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19),
[ADR-AUTO-TEST#20](/docs/adr/automation/test-automation.md#rule-adr-auto-test20)): it prefixes each check's issues
with the check's code (pinned at L0 above), so each check's It reads its own issues from that run rather than
running the check a second time.
```
