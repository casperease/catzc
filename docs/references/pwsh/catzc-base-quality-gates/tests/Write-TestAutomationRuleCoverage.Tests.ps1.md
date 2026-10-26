# pwsh/Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:allRuleIds = @('ADR-FAKE-TURN', 'ADR-FAKE-PULL', 'ADR-FAKE-FOLD',...`, written with `#`.

```text
A fake rule universe (not the real docs) keeps this hermetic — the writer is a pure function of its
inputs. Two rules covered by tests, two by analyzers, one by neither.
```
