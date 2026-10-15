---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-Go.ps1.md
    kind: comment-page
    body_sha: afe8bd933c45
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Toolchain/Uninstall-Go.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes the managed user-space home (Get-ScriptInstallDir: Windows %LOCALAPPDATA%\go, Unix ~/.go) and takes
its bin folder off the session and persistent PATH — the managed uninstall. Idempotent — skips when the home
does not exist. A Go installed elsewhere (a machine-wide MSI, a distro package) is not the managed install and
is left untouched. The module cache and build cache (GOPATH, GOCACHE) are Go's own data, not the install, and
are kept.
```
