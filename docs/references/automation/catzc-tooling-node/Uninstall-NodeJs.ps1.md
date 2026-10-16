---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-node/Uninstall-NodeJs.ps1.md
    folder: docs/references/automation/catzc-tooling-node
    name: uninstall-node-js-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6bb2016d2353"
    adrs:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#5
---

# automation/Catzc.Tooling.Node/Uninstall-NodeJs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `try {`, written with `#`.

```text
Managed uninstall best-effort; with -Remove a failure (a foreign install) is logged and the escalation
proceeds, without -Remove it propagates
([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```
