---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "26c010fc3baf"
    adrs:
      - ADR-CONF-LOADING#4
      - ADR-REPO-FILEMETA#2
---

# automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The meta-kind registry (file-meta.yml): which kinds of derived fact and of config contribution exist is data, never a list in an engine.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4)
```
