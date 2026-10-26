# pwsh/Base.Languages/configs/file-carriers.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `carriers:`, written with `#`.

```text
Where each file class keeps its meta block, or the reason it has none; a class with files: wins over a language of the same file.
[ADR-REPO-FILEMETA-HEADPOLICY](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy),
[PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](/docs/drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig),
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)
```

## comment:2

Above `diagram-render:`, written with `#`.

```text
Classes of files that belong to no language.
A diagram's render carries no block: the <name>.drawio.yml beside it is the diagram's one source.
```

## comment:3

Above `msbuild-project: { files: ["pwsh/.internal/assets/Catzc.Types.csproj",...`, written with `#`.

```text
An XML comment cannot hold the fence and an editor's project loader refuses a processing instruction, so the block is a CDATA
property of the project's first labelled property group.
```
