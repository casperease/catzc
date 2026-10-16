---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/types/KeyHandlerSupportedConfig.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "22c1658729e5"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The PSReadLine functions supported on Linux, configs/key-handler-supported.yml — the allow-list
Import-PSReadLineKeyHandlerSet filters the captured bindings against, so a Windows-only function is skipped rather
than throwing. Constructing an instance MAPS and VALIDATES the parsed YAML, collecting every violation into one
throw. Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Tooling.KeyHandler.KeyHandlerSupportedConfig),
so Get-Config -Config key-handler-supported returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - a mapping whose only key is 'functions';
  - 'functions' is a non-empty list of non-blank function names.
```
