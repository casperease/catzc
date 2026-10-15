---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/configs/configs.yml.md
    kind: comment-page
    body_sha: "98fe9057ddcb"
    adrs: []
    links: []
---

# automation/Catzc.Base.Config/configs/configs.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `configs:`.

```text
Config registry for Get-Config: every shipped config's C# config type (Test-ShippedConfigs checks that each
shipped configs/<name>.yml has an entry and loads, and that each entry names a shipped config).

  <config-name>:
    type: <C# FQN>         # construct [FQN]::new($dict) — maps + validates
    overridable: false     # optional; a consumer overlay may not change this config (default: true). Only the
                           # engine-intrinsic configs are sealed ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)).

The registry validates ITSELF: the 'configs' config (this file) is validated by the C# type below.
Get-ConfigRegistry constructs it on load.
```
