---
catzc:
  immutable:
    with_body_sha: "6d12d5cc0bb7"
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-PythonLint.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-python-lint-tests-ps1
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

# automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-PythonLint' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-PythonLint is a quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
the L0 cases mock the scope and ruff at the module boundary and read the collected issues; the report goes to
$TestDrive. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Repository Python lint integrity' -Tag 'L2', 'integrity',...`, written with `#`.

```text
Integrity: every Python file the repository holds passes ruff check — the Python tests and the agent helpers. L2
because it drives the pinned ruff through uv; self-skips without uv or the pinned interpreter
([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)/9). source-only: it reads the
repository's own files, which give the same answer in both run modes.
```
