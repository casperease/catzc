# docs/references/automation/catzc-tooling-node/Install-Prettier.ps1.md

`automation/Catzc.Tooling.Node/Install-Prettier.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Prettier is the engine Format-Code runs for every file language languages.yml gives `formatter: prettier`
(Markdown, pipeline YAML). It is installed globally with npm at the version locked in tools.yml. Requires Node.js (npm). Idempotent — skips if already installed at the
locked version; -Force replaces a wrong version.
```
