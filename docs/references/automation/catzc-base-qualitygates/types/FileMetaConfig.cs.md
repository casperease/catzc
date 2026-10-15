---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md
    kind: comment-page
    body_sha: "7225b667179e"
    adrs:
      - ADR-CONF-LOADING#4
      - ADR-REPO-FILEMETA#2
    links: []
---

# automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The meta-kind registry (file-meta.yml): which kinds of derived fact and of config contribution exist is data, never a list in an engine.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4)
```
