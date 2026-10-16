---
catzc:
  immutable:
    with_body_sha: "810ca4ad194b"
    path: docs/references/automation/catzc-base-config/configs/configs.yml.md
    folder: docs/references/automation/catzc-base-config/configs
    name: configs-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Config/configs/configs.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `configs:`, written with `#`.

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
