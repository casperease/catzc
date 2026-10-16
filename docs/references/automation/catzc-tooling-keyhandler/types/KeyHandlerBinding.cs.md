---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/types/KeyHandlerBinding.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ec5fc031a675
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One captured PSReadLine key binding of configs/key-handler-bindings.yml (`- key: <chord>` / `function: <name>`),
written by Save-PSReadLineKeyHandlerSet and replayed by Import-PSReadLineKeyHandlerSet. Constructing one MAPS and
VALIDATES the entry: a mapping carrying a non-empty 'key' and 'function' (the only two keys the capture writes);
every violation is reported in one throw, prefixed with the entry's position. Mirrors the YAML mapping
(snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
