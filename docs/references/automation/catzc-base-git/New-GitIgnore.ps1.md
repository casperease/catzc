---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/New-GitIgnore.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "2916e7b4f989"
---

# automation/Catzc.Base.Git/New-GitIgnore.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$patterns = if ($section.inject) {`, written with `#`.

```text
Resolve the section's patterns: static from the registry, or injected by the caller. An inject
provider the caller did not supply is a wiring defect — fail loudly, never render a silently
incomplete .gitignore.
```
