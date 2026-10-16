---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Install-UvTool.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: cb6b02e0845f
---

# automation/Catzc.Tooling.Core/Install-UvTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Invoke-Uv "tool install $($config.uv_tool)==$Version.*"...`, written with `#`.

```text
uv resolves the package's own compatible Python and installs it in an isolated env. Pre-release resolution
(for packages that pin a beta dependency) is threaded through Invoke-Uv's -Prerelease switch, which warns.
```
