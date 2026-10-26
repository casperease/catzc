# pwsh/Base.QualityGates/tests/ConvertTo-TestAutomationRowSet.Tests.ps1

The tests of `ConvertTo-TestAutomationRowSet`, the reducer that turns Pester results into report rows. `New-FakeTest` builds a Pester-shaped
result without running Pester: only the members the reducer reads (`Result`, `Duration`, `ExpandedPath` and `Name`, `ErrorRecord`, the
block tag chain, and the script block's file and line).
