# pwsh/Catzc.Base.Docs/tests/Resolve-AdrLinkTarget.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Resolve-AdrLinkTarget' -Tag 'L0', 'logic',...`, written with `#`.

```text
Resolve-AdrLinkTarget — a markdown link in a file under docs/adr/, resolved relative to its file
([ADR-REPO-LINK-MARKDOWNRELATIVE](/docs/adr/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)) to its path under docs/adr/. Pure path logic: the
fixture root need not exist. Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
