---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md
    kind: reference
    body_sha: e016652d3536
    adrs:
      - ADR-AUTO-CACHE#5
---

# automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The pure decision core of Import-PSReadLineKeyHandlerSet, separated so it is deterministic and
testable without a real PSReadLine session (see
[ADR-AUTO-TEST](/docs/adr/automation/test-automation.md) push-left). Given the captured bindings
and the allow-list of supported function names, returns one record per binding carrying its Key,
Function, and a Supported flag — the caller applies the supported ones and logs the rest. Reads
the inputs only; never mutates the cached config objects
([ADR-AUTO-CACHE#5](/docs/adr/automation/caching.md#rule-adr-auto-cache5)).
```
