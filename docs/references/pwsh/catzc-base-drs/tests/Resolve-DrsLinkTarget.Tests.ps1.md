# pwsh/Base.Drs/tests/Resolve-DrsLinkTarget.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Resolve-DrsLinkTarget'`, written with `#`.

```text
Resolve-DrsLinkTarget — a markdown link in a file under docs/drs/, resolved relative to its file
([ADR-REPO-LINK-MARKDOWNRELATIVE](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)) to its path under docs/drs/. Pure path logic: the
fixture root need not exist. Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
