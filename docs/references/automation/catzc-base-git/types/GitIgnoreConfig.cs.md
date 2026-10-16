---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/types/GitIgnoreConfig.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "27428b771eb8"
---

# automation/Catzc.Base.Git/types/GitIgnoreConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The gitignore registry (configs/gitignore.yml) and its validity rules: a required 'sections' list of
explained pattern groups, each validated by GitIgnoreSection, with unique section ids. Constructing an
instance validates the registry (collecting every malformed section into one error) and exposes the parsed
sections to the renderer (New-GitIgnore). Registered as the `gitignore` config's type override in
Catzc.Base.Config/configs/configs.yml. See [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md) and
[ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```
