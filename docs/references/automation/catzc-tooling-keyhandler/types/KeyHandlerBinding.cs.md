---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/types/KeyHandlerBinding.cs.md
    kind: comment-page
    body_sha: b3810deee108
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One captured PSReadLine key binding of configs/key-handler-bindings.yml (`- key: <chord>` / `function: <name>`),
written by Save-PSReadLineKeyHandlerSet and replayed by Import-PSReadLineKeyHandlerSet. Constructing one MAPS and
VALIDATES the entry: a mapping carrying a non-empty 'key' and 'function' (the only two keys the capture writes);
every violation is reported in one throw, prefixed with the entry's position. Mirrors the YAML mapping
(snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
