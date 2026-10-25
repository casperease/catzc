# pwsh/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ConvertTo-ContractNoteMarkdown'`, written with `#`.

```text
A note is written as a comment, where a citation is a repository-rooted code link
([ADR-REPO-LINK-CODELINKS](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-codelinks)); in a list item of a generated page it
is markdown, so a rooted link turns relative to the page
([ADR-REPO-LINK-MARKDOWNRELATIVE](/docs/drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)). Fixtures are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
