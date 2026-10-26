# pwsh/Base.Git/tests/New-GitIgnore.Tests.ps1

The tests of `New-GitIgnore`: they render a small fixture registry.

## The config seam

The tests isolate through the config seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): a small
fixture registry with one static section (a noted and a bare pattern) and one injected section.
