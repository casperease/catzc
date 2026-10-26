# pwsh/Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1

The test of `Write-TestAutomationRuleCoverage`. A fake rule universe, not the real docs, keeps it hermetic, because the writer is a pure
function of its inputs. In the universe, two rules are covered by tests, two by analyzers, and one by neither.
