# pwsh/Base.CodeMeta/types/PropertyHead.cs

Reads and writes a file's meta block, kept as the text of one property, as pure text work on strings
([ADR-REPO-FILEMETA-JSONCARRIER](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-jsoncarrier)).

## Carriers

- A JSON file keeps the block as an ignored top-level member.
- An XML file the carriers declare as a property carrier, an MSBuild project or `nuget.config` (a configuration root), keeps it as a CDATA
  property of a labelled first PropertyGroup. An XML comment cannot hold the `---` fence and a loader may refuse a processing instruction,
  so neither is used.

## Writing

`WithFacts` returns the whole text again with the property written from the place facts and the edges in the order given and the authored
config kept; nothing to write removes it. A text that is no object, or whose property holds something foreign, comes back as it was.
