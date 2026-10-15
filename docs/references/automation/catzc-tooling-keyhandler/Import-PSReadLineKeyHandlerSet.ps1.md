---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-keyhandler/Import-PSReadLineKeyHandlerSet.ps1.md
    kind: comment-page
    body_sha: "17d1d5012ca2"
---

# automation/Catzc.Tooling.KeyHandler/Import-PSReadLineKeyHandlerSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
PSReadLine on Linux defaults to bash-style editing; this replicates the Windows editing experience by
applying the captured bindings (configs/key-handler-bindings.yml) through Set-PSReadLineKeyHandler,
skipping any function the Linux build does not support (configs/key-handler-supported.yml) so an
unsupported binding is dropped rather than throwing. Runs on Linux only — applying Windows bindings on a
Windows session would clobber its native handlers, so the real apply path asserts $IsLinux. Use -DryRun
to see the plan (which bindings apply, which are skipped) on any platform without changing the session.
```
