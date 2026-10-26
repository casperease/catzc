# pwsh/Base.Docs/types/DocsConfig.cs

The README copy-in registry (`configs/readme.yml`) and its validity rules. It holds an optional `patterns` list of glob-derived source
conventions, an optional `mappings` list of explicit folder-to-source entries, and an optional `without_article` list of pattern-matched
folders allowed to have no article, with at least one entry across `patterns` and `mappings`.

Constructing an instance validates the registry, collecting the malformed shapes into one `ArgumentException`, and exposes the parsed
entries to the generator (`Build-Readme`, which expands the patterns against the filesystem via `Get-ReadmeMappings`). It is registered as
the `readme` config's type override in `Catzc.Base.Config/configs/configs.yml`. See
[ADR-CONF-LOADING](../../../../drs/configuration/module-config-loading.md) and
[ADR-REPO-README](../../../../drs/repository/generated-readmes.md).
