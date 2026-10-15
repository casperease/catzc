---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Test-CheckedInBinaries.Tests.ps1.md
    kind: test-asset
    body_sha: "036a9535e73d"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-CheckedInBinaries' -Tag 'L0', 'logic' {`.

```text
Test-CheckedInBinaries over fixture files in $TestDrive with the git CLI mocked: `ls-files --eol` and
`check-attr binary` answer from each test's listing, so each test pins one storage rule. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Checked-in binaries are stored as binary, not text' -Tag 'L2',...`.

```text
The real repository through the quality gate (Test-CheckedInBinaries —
[ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
```

## comment:3

Above `if (-not (Get-Command git -ErrorAction Ignore)) {`.

```text
L2: drives the real git CLI. Self-skip when git is absent or we are not inside a work tree
(e.g. running from an exported tarball), per the test-automation tiering ADR.
```
