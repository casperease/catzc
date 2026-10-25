# pwsh/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Manual test plan covers every integrity check'`, written with `#`.

```text
Keeps the manual test plan's category files (docs/how-to/pwsh/manual-test-plan/) in sync with the tests, through its quality gate
(Test-ManualTestPlan — [ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). The gate
derives the integrity blocks by PARSING the test files, never by booting Pester discovery
([ADR-AUTO-TEST-INTEGRITYREADSFILES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-integrityreadsfiles)). It is self-referential: this
Describe is integrity-tagged, so the plan lists it too. source-only: it reads the repository's test files and the
plan document, which give the same answer in both run modes.
```
