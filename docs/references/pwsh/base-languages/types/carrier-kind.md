# pwsh/Base.Languages/types/CarrierKind.cs

Where a file keeps its meta block: in its own text (front matter, comment head, ignored property), in a writer's stamp inside a format with
no comment (a png `tEXt` chunk, an svg `<metadata>` element, an xml processing instruction), or nowhere
([ADR-REPO-FILEMETA-HEADPOLICY](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy),
[ADR-REPO-FILEMETA-EVERYFORMATCARRIES](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-everyformatcarries)). The kinds of a
`FileCarrier`. The imprint reads and writes the three text kinds only; the stamp kinds are filled by a writer alone.
