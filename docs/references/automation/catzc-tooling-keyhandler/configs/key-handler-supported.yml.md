---
catzc:
  immutable:
    with_body_sha: "76df95b93b6e"
    path: docs/references/automation/catzc-tooling-keyhandler/configs/key-handler-supported.yml.md
    folder: docs/references/automation/catzc-tooling-keyhandler/configs
    name: key-handler-supported-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
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
