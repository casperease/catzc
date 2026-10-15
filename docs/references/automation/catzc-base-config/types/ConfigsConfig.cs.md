---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/types/ConfigsConfig.cs.md
    kind: comment-page
    body_sha: bf51f6820110
---

# automation/Catzc.Base.Config/types/ConfigsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The config registry (configs/configs.yml) and its validity rules. The registry binds each shipped config
name to the C# config type Get-Config constructs it as; this type's only job is to enforce that shape at
construction time, so a malformed registry can never produce an instance.

The data model it guards: under the top-level `configs` map, each entry is a map holding `type` (a non-blank
C# type FQN) and, optionally, `overridable` (a boolean; absent means true); `configs` is the only top-level
key. An absent or empty `configs` map is valid. `configs` exposes the registry as config name -> type FQN, in
file order; `sealedConfigs` names the entries a consumer overlay may not change (overridable: false — the
engine-intrinsic configs, [ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)).
```
