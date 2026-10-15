---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/New-GitIgnore.ps1.md
    kind: comment-page
    body_sha: "57648ddae143"
---

# automation/Catzc.Base.Git/New-GitIgnore.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$patterns = if ($section.inject) {`.

```text
Resolve the section's patterns: static from the registry, or injected by the caller. An inject
provider the caller did not supply is a wiring defect — fail loudly, never render a silently
incomplete .gitignore.
```
