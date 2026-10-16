---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/configs/key-handler-supported.yml.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "76df95b93b6e"
---

# automation/Catzc.Tooling.KeyHandler/configs/key-handler-supported.yml

<!-- cspell:ignore begining -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `functions:`, written with `#`.

```text
PSReadLine functions supported on Linux — the allow-list Import-PSReadLineKeyHandlerSet filters
key-handler-bindings against, so a Windows-only function is skipped rather than throwing.
```
