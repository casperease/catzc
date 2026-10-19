# pwsh/Catzc.Base.Git/tests/New-GitIgnore.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.Git {`, written with `#`.

```text
Isolate through the config seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/adr/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): a small
fixture registry with one static section (a
noted and a bare pattern) and one injected section.
```
