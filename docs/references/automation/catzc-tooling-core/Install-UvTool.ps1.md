# docs/references/automation/catzc-tooling-core/Install-UvTool.ps1.md

`automation/Catzc.Tooling.Core/Install-UvTool.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Mirrors Install-Tool's contract but installs via `uv tool install <uv_tool>==<version>.*` — each tool gets
its own isolated environment with uv's managed Python (user-space, no admin, no shared-env pollution).
Used for az_cli, poetry, and other Python-based CLIs. Handles idempotency, -Force, and version verify.
uv is the install mechanism, so it must be present (Invoke-Uv asserts it).
```

## comment:2

Above `Invoke-Uv "tool install $($config.uv_tool)==$Version.*"...`.

```text
uv resolves the package's own compatible Python and installs it in an isolated env. Pre-release resolution
(for packages that pin a beta dependency) is threaded through Invoke-Uv's -Prerelease switch, which warns.
```
