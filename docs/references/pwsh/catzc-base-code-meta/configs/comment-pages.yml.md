# pwsh/Base.CodeMeta/configs/comment-pages.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `pages:`, written with `#`.

```text
Where a file's comment page lives, first match wins. `source` is a folder, or `<prefix>/*` for each immediate
subfolder of the prefix (dot-prefixed folders never match, so .vendor is out and .scriptanalyzer and .internal are
listed by name); `docs` is the
folder under docs/ the pages go under, and with a `/*` source `{kebab}` is the matched subfolder's leaf name,
rendered in the kebab case of NameCase. The page keeps the file's name and extension plus `.md`
(pwsh/Base.QualityGates/Format-Code.ps1 -> docs/references/pwsh/catzc-base-quality-gates/Format-Code.ps1.md).
```
