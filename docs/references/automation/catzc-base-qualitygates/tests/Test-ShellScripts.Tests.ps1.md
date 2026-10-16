---
catzc:
  immutable:
    with_body_sha: "250d5008a32d"
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-ShellScripts.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-shell-scripts-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{3,8,35}
---

# automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ShellScripts' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-ShellScripts is a quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
the L0 cases run over a fixture repository in $TestDrive with the index, the tool probe, and ShellCheck mocked, and
read the collected issues; the report goes to $TestDrive. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Repository shell script integrity' -Tag 'L2', 'integrity',...`, written with `#`.

```text
Integrity: every shell script the repository holds is LF and passes the pinned ShellCheck. L2 because it drives the
ShellCheck CLI; self-skips without it ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)).
source-only: it reads the repository's own files.
```
