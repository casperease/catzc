---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Invoke-AzCli.ps1.md
    kind: comment-page
    body_sha: e40c1a70a6ab
---

# automation/Catzc.Azure.Cli/Invoke-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$dynamicInstallVar = 'AZURE_EXTENSION_USE_DYNAMIC_INSTALL'`.

```text
Disable az dynamic extension install for this call: a command needing an uninstalled extension
then exits non-zero instead of blocking on an invisible "(Y/n)" prompt, which Invoke-Executable's
exit-code assertion turns into a throw. Scoped to the process and restored afterwards; skipped on
a dry run, which never launches az. $null restores an unset variable to unset (not empty).
```
