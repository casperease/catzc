---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/private/Get-RootConfigTargets.ps1.md
    kind: comment-page
    body_sha: "91de9fc4fa8d"
    adrs: []
    links: []
---

# automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Filters the validated registry (Get-Config -Config rootconfig) down to the entries with optIn true — the
files the automation actually manages. Opted-out entries are inert: validated for shape when the config
loads, but neither written nor treated as owned. The full registry semantics live in
configs/rootconfig.yml; see [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```
