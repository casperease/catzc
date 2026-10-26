# pwsh/Base.Docs/private/Get-ReadmeContent.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Composes a generated README: its source article, links rebased to the README's folder, under a line naming the source.

### description

The source link line goes after the source's title when it has one, else at the top of the README. The source's front matter, The one
composer behind Build-Readme (the writer) and Test-GeneratedReadmes (the quality gate). The source's relative links are rebased from the
source's folder to the README's (MarkdownLinkRebaser), so every link works where the README is opened; a line under the title links back to
the source as the one place to edit
([ADR-REPO-README-WORKINGLINKS](../../../../drs/repository/generated-readmes.md#rule-adr-repo-readme-workinglinks)). The line goes after the
source's '# ' title when it opens with one, else at the top. The copy opens with its own meta block, whose `kind` is the one the file-kinds
registry names for the README, above both.

### parameter `Mapping`

One readme.yml mapping as Get-ReadmeMappings returns it ({ folder; source }, repository-relative).

### outputs

`[string]` The README's content (LF line endings).

## comment:1

Above `$body = Format-LongMarkdownLines -Text...`, written with `#`.

```text
The rebased links are longer than the source's, so a line the source wrapped at the width can pass it here; wrap
those blocks again.
```
