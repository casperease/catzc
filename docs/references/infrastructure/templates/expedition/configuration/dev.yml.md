---
catzc:
  derived:
    path: docs/references/infrastructure/templates/expedition/configuration/dev.yml.md
    kind: comment-page
    body_sha: "517ad215dc65"
    adrs: []
---

# infrastructure/templates/expedition/configuration/dev.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `ParametersFile:`.

```text
expedition, shared dev (configuration root, shared_nonprod subscription): in the nonprod hub's shared-services
subnet, registered in the same hub's private DNS zones. Nonprod class: a serverless database that pauses when
idle.
```
