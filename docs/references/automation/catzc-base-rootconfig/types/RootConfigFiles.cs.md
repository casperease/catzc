---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md
    folder: docs/references/automation/catzc-base-rootconfig/types
    name: root-config-files-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e074da723ab0
---

# automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The root-config registry (configs/rootconfig.yml) and its validity rules: a required 'files' list of
managed root-file entries, each validated by RootConfigFile, with unique targets. Constructing an instance
validates the registry (collecting every malformed entry into one error) and exposes the parsed entries to
the generator (Build-RootConfig). Registered as the `rootconfig` config's type override in
Catzc.Base.Config/configs/configs.yml. See [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md) and
[ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```
