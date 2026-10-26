# pwsh/Base.QualityGates/types/FileMetaKind.cs

One entry of the meta-kind registry ([ADR-REPO-FILEMETA-METAKIND](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-metakind)).
The defaults of an omitted key are declared here, once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Convention name

`ConventionName` gives the function a module subscribes by default: `Get-<Id>FileMetaFact` for an imprint kind, or
`Get-<Id>MarkdownConfigContribution` for a gather kind
([ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-subscribebyfunction)).
