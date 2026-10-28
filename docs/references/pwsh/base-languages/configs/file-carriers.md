# pwsh/Base.Languages/configs/file-carriers.yml

The file-carriers registry: where each file class keeps its meta block, or the reason it has none
([ADR-REPO-FILEMETA-HEADPOLICY](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy)). The entry is configuration, not
code ([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)),
and its omitted keys take the defaults declared once on the type
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Entries

- **`carriers`** — one entry per file class. A class with `files:` wins over a language of the same file.
- **`diagram-render`**, **`png`** — a generated picture carries its writer's stamp in a `tEXt` chunk keyed `catzc`, and its body hash hashes
  the image without that chunk
  ([ADR-REPO-FILEMETA-EVERYFORMATCARRIES](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-everyformatcarries)).
- **`svg`** — the stamp is a `<metadata>` element. **`xml`** — an XML comment may not contain `--`, so the stamp is a `<?catzc ...?>`
  processing instruction.
- **`asset`** — the binaries left once `png` and `svg` take theirs, a pdf or an archive, carry no block.
- **`msbuild-project`** — an XML comment cannot hold the fence and an editor's project loader refuses a processing instruction, so the block
  is a CDATA property of the project's first labelled property group.

## How it is read

`Get-Config -Config file-carriers` loads the file into the typed `FileCarriersConfig` (`FileCarriersConfig.cs`), which builds one
`FileCarrier` per entry.
