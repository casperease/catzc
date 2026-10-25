# pwsh/Catzc.Base.Docs/types/DocsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The README copy-in registry (configs/readme.yml) and its validity rules: an optional 'patterns' list of
glob-derived source conventions and an optional 'mappings' list of explicit folder->source entries, with at
least one entry across the two. Constructing an instance validates the registry (throwing on the first
malformed shape) and exposes the parsed patterns and mappings to the generator (Build-Readme, which expands
the patterns against the filesystem via Get-ReadmeMappings). Registered as the `readme` config's type
override in Catzc.Base.Config/configs/configs.yml. See [ADR-CONF-LOADING](/docs/drs/configuration/module-config-loading.md) and
[ADR-REPO-README](/docs/drs/repository/generated-readmes.md).
```
