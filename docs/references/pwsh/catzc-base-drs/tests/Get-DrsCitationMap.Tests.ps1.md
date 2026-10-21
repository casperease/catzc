# pwsh/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AdrCitationMap' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-AdrCitationMap builds the citation registry the link engine derives every code link from
([ADR-REPO-LINK-CODELINKS](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-codelinks)).
A fixture repository in $TestDrive carries a two-ADR index (neutral widget/gadget codes,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) and two
code-less documents that share a file name, so the slug lookup's ambiguity is exercised too.
```
