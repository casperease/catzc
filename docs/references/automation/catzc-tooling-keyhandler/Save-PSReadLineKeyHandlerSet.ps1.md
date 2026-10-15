---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/Save-PSReadLineKeyHandlerSet.ps1.md
    kind: comment-page
    body_sha: ff51f22037be
---

# automation/Catzc.Tooling.KeyHandler/Save-PSReadLineKeyHandlerSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The Windows-side capture step: serializes the active Set-PSReadLineKeyHandler bindings (key + function
only — the pair Import-PSReadLineKeyHandlerSet consumes) as YAML so they can be replayed on Linux. Run it
in a Windows session whose editing experience is the one to replicate, then commit the regenerated config.
Writes canonically (UTF-8, LF, one trailing newline) through Write-FileIfChanged, so re-capturing an
unchanged session is a no-op.
```

## comment:2

Section `.PARAMETER Path` of the comment-based help.

```text
Target file. Defaults to the catzc source tree's
automation/Catzc.Tooling.KeyHandler/configs/key-handler-bindings.yml — the authored config that
Import-PSReadLineKeyHandlerSet reads back once loaded. The default needs a session running the source tree
(Assert-SourceTree), so a capture is never written into a built package.
```
