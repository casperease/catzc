# docs/references/automation/catzc-base-qualitygates/private/Assert-TestTagGate.ps1.md

`automation/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Enforces the two mandatory tag axes (tier L0-L4 + category logic|integrity,
[ADR-AUTO-TEST#13](/docs/adr/automation/test-automation.md#rule-adr-auto-test13)/15) on every
test of the run's discovery pass. The discovery sees all tests regardless of -Level, so a missing or
ambiguous tag fails the run even when its tier would be excluded. Each violation is listed in red before the
throw (Get-TestTagViolations owns the rules, including the optional-tag and citation checks).
```
