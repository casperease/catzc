---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-ShellScripts.Tests.ps1.md
    kind: test-asset
    body_sha: "832a558d06c7"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
      - ADR-AUTO-TEST#8
---

# automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ShellScripts' -Tag 'L0', 'logic' {`.

```text
Test-ShellScripts is a quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
the L0 cases run over a fixture repository in $TestDrive with the index, the tool probe, and ShellCheck mocked, and
read the collected issues; the report goes to $TestDrive. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Repository shell script integrity' -Tag 'L2', 'integrity',...`.

```text
Integrity: every shell script the repository holds is LF and passes the pinned ShellCheck. L2 because it drives the
ShellCheck CLI; self-skips without it ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)).
source-only: it reads the repository's own files.
```
