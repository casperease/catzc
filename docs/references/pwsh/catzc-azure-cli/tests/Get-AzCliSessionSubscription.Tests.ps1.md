# automation/pwsh/Catzc.Azure.Cli/tests/Get-AzCliSessionSubscription.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The session read is a whole-function boundary mock
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](/docs/adr/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)); config discovery
redirects to
the fixture identities, so nothing production is in play.
```
