---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Test-CheckedInBinaries.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: cddb97f412f4
    adrs:
      - ADR-AUTO-TEST#{3,35}
---

# automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-CheckedInBinaries' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-CheckedInBinaries over fixture files in $TestDrive with the git CLI mocked: `ls-files --eol` and
`check-attr binary` answer from each test's listing, so each test pins one storage rule. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Checked-in binaries are stored as binary, not text' -Tag 'L2',...`, written with `#`.

```text
The real repository through the quality gate (Test-CheckedInBinaries —
[ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
```

## comment:3

Above `if (-not (Get-Command git -ErrorAction Ignore)) {`, written with `#`.

```text
L2: drives the real git CLI. Self-skip when git is absent or we are not inside a work tree
(e.g. running from an exported tarball), per the test-automation tiering ADR.
```
