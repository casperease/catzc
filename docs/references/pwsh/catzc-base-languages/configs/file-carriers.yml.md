# pwsh/Catzc.Base.Languages/configs/file-carriers.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `carriers:`, written with `#`.

```text
Where each file class keeps its meta block, or the reason it has none; a class with files: wins over a language of the same file.
[ADR-REPO-FILEMETA-HEADPOLICY](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy),
[PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](/docs/adr/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig),
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)
```

## comment:2

Above `diagram-folder:`, written with `#`.

```text
Classes of files that belong to no language.
A diagram folder's render carries no block: the diagram.drawio.yml beside it is the diagram's one source.
```
