---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Connect-AzCli.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0745db6e4ee9"
---

# automation/Catzc.Azure.Cli/Connect-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (-not $Force) {`, written with `#`.

```text
Idempotent: skip if already logged in with the correct identity
-NoAssert: non-zero exit means "not logged in" — an expected state, not an error
```

## comment:2

Above `Write-Verbose "Authenticating via $($PSCmdlet.ParameterSetName)"`, written with `#`.

```text
No post-login assertion needed — Invoke-Executable throws on non-zero exit
codes via Assert-LastExitCodeWasZero. If az login fails, we never reach the
Write-Message below.
```
