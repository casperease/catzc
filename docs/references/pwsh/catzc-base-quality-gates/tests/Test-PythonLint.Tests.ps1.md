# pwsh/Base.QualityGates/tests/Test-PythonLint.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-PythonLint'`, written with `#`.

```text
Test-PythonLint is a quality gate ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)):
the L0 cases mock the scope and ruff at the module boundary and read the collected issues; the report goes to
$TestDrive. Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'Repository Python lint integrity'`, written with `#`.

```text
Integrity: every Python file the repository holds passes ruff check — the Python tests and the agent helpers. L2
because it drives the pinned ruff through uv; self-skips without uv or the pinned interpreter
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](/docs/drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)/9). source-only: it reads the
repository's own files, which give the same answer in both run modes.
```
