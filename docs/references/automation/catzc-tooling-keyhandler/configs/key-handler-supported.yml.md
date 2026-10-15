---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/configs/key-handler-supported.yml.md
    kind: reference
    body_sha: eec256f06f25
    adrs: []
---

# automation/Catzc.Tooling.KeyHandler/configs/key-handler-supported.yml

<!-- cspell:ignore begining -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `functions:`.

```text
PSReadLine functions supported on Linux — the allow-list Import-PSReadLineKeyHandlerSet filters
key-handler-bindings against, so a Windows-only function is skipped rather than throwing.
```
