# pwsh/Catzc.Base.Docs/tests/types/MarkdownLinkRebaser.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'MarkdownLinkRebaser' -Tag 'L0', 'logic',...`, written with `#`.

```text
A generated README copies an article into another folder; its relative links are rebased so they resolve there
([ADR-REPO-README-WORKINGLINKS](/docs/drs/repository/generated-readmes.md#rule-adr-repo-readme-workinglinks)).
```
