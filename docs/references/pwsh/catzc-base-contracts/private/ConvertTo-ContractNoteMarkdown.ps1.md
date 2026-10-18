# pwsh/Catzc.Base.Contracts/private/ConvertTo-ContractNoteMarkdown.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Turns a contract asset's note into the markdown text of its list item on a generated page.

### description

A note is written as a comment (Get-ContractAssetNote), where an ADR citation is a repository-rooted code link
([ADR-REPO-LINK#3](../../../../adr/repository/markdown-links.md#rule-adr-repo-link3)). On the generated page it is markdown, so each part is
rewritten to its markdown form:

- a link whose destination starts with '/' becomes relative to the page's folder, its #fragment kept
  ([ADR-REPO-LINK#2](../../../../adr/repository/markdown-links.md#rule-adr-repo-link2));
- a bare <https://> or <http://> address becomes an autolink, `<address>`, so it renders as a link and is not a bare URL;
- a '<' that opens no autolink is escaped, so it is never read as inline HTML.

Code spans keep their text; every other link and autolink is left as written.

### parameter `Note`

The note, one line.

### parameter `PageFolder`

The repository-relative folder of the page the note is written to, '/'-separated.

### outputs

`[string]` The note as markdown.

### example 1

```powershell
ConvertTo-ContractNoteMarkdown -Note $note -PageFolder 'docs/references/contracts'
```
