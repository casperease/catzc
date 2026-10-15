---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Install-UvTool.ps1.md
    kind: comment-page
    body_sha: "830e0bdc3806"
---

# automation/Catzc.Tooling.Core/Install-UvTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `Invoke-Uv "tool install $($config.uv_tool)==$Version.*"...`.

```text
uv resolves the package's own compatible Python and installs it in an isolated env. Pre-release resolution
(for packages that pin a beta dependency) is threaded through Invoke-Uv's -Prerelease switch, which warns.
```
