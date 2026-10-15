---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Get-ToolVersion.ps1.md
    kind: comment-page
    body_sha: "8fb6b90a307e"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Core/Get-ToolVersion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Executes the version_command from tools.yml, matches against
version_pattern, and returns the captured version string.
Returns $null if the command fails or the pattern does not match.
Uses .Full (stdout + stderr merged) to catch tools like java that
write version info to stderr.
```
