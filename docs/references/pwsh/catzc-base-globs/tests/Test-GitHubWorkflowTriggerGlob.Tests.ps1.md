# pwsh/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-GitHubWorkflowTriggerGlob' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-GitHubWorkflowTriggerGlob is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35), drift detection): a workflow's
actual paths vs the globset's ordered projection (GitHub paths are last-match-wins). Neutral fixtures (widget,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the report goes to $TestDrive.
```
