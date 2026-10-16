---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/DocsConfig.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ea3398a7b8bd
---

# automation/Catzc.Base.Docs/types/DocsConfig.cs

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
override in Catzc.Base.Config/configs/configs.yml. See [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md) and
[ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
```
