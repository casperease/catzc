---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Invoke-AzCli.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "1c273f04597f"
---

# automation/Catzc.Azure.Cli/Invoke-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$dynamicInstallVar = 'AZURE_EXTENSION_USE_DYNAMIC_INSTALL'`, written with `#`.

```text
Disable az dynamic extension install for this call: a command needing an uninstalled extension
then exits non-zero instead of blocking on an invisible "(Y/n)" prompt, which Invoke-Executable's
exit-code assertion turns into a throw. Scoped to the process and restored afterwards; skipped on
a dry run, which never launches az. $null restores an unset variable to unset (not empty).
```
