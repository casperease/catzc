---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
    kind: reference
    body_sha: b52f3850a453
    adrs: []
---

# automation/Catzc.Base.Git/types/GitIgnoreConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The gitignore registry (configs/gitignore.yml) and its validity rules: a required 'sections' list of
explained pattern groups, each validated by GitIgnoreSection, with unique section ids. Constructing an
instance validates the registry (collecting every malformed section into one error) and exposes the parsed
sections to the renderer (New-GitIgnore). Registered as the `gitignore` config's type override in
Catzc.Base.Config/configs/configs.yml. See [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md) and
[ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```
