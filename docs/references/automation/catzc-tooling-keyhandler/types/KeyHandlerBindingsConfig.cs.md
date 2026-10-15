---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/types/KeyHandlerBindingsConfig.cs.md
    kind: comment-page
    body_sha: "8da8c45e43eb"
---

# automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBindingsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The captured Windows PSReadLine key bindings, configs/key-handler-bindings.yml: a top-level SEQUENCE of
{ key, function } entries (KeyHandlerBinding), written by Save-PSReadLineKeyHandlerSet and replayed on Linux by
Import-PSReadLineKeyHandlerSet. The YAML has no top-level key, so the sequence is exposed as `bindings`.
Constructing an instance MAPS and VALIDATES the parsed YAML — a non-empty sequence of well-formed entries —
collecting every violation into one throw, so a malformed capture fails at read time rather than mid-import.
Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Tooling.KeyHandler.KeyHandlerBindingsConfig), so
Get-Config -Config key-handler-bindings returns this typed model.
```
