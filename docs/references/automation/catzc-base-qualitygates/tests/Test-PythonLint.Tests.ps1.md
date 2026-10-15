---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-PythonLint.Tests.ps1.md
    kind: test-asset
    body_sha: "46c23d7594c5"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
      - ADR-AUTO-TEST#8
---

# automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-PythonLint' -Tag 'L0', 'logic' {`.

```text
Test-PythonLint is a quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
the L0 cases mock the scope and ruff at the module boundary and read the collected issues; the report goes to
$TestDrive. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Repository Python lint integrity' -Tag 'L2', 'integrity',...`.

```text
Integrity: every Python file the repository holds passes ruff check — the Python tests and the agent helpers. L2
because it drives the pinned ruff through uv; self-skips without uv or the pinned interpreter
([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)/9). source-only: it reads the
repository's own files, which give the same answer in both run modes.
```
