---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Invoke-AzCli.ps1.md
    kind: comment-page
    body_sha: b19a71229c44
---

# automation/Catzc.Azure.Cli/Invoke-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Asserts that the installed Azure CLI version matches the locked version
in Get-ToolConfig before executing the command.

Dynamic extension install is disabled for the duration of the call
(AZURE_EXTENSION_USE_DYNAMIC_INSTALL=no), so a command that requires an
uninstalled extension fails with a non-zero exit code instead of blocking
on an interactive "(Y/n)" install prompt that captured stdin would hide.
That failure surfaces through the usual exit-code assertion as a throw.
```

## comment:2

Above `$dynamicInstallVar = 'AZURE_EXTENSION_USE_DYNAMIC_INSTALL'`.

```text
Disable az dynamic extension install for this call: a command needing an uninstalled extension
then exits non-zero instead of blocking on an invisible "(Y/n)" prompt, which Invoke-Executable's
exit-code assertion turns into a throw. Scoped to the process and restored afterwards; skipped on
a dry run, which never launches az. $null restores an unset variable to unset (not empty).
```

## comment:3

Above `$dynamicInstallVar = 'AZURE_EXTENSION_USE_DYNAMIC_INSTALL'`.

```text
Disable az dynamic extension install for this call: a command needing an uninstalled extension
then exits non-zero instead of blocking on an invisible "(Y/n)" prompt, which Invoke-Executable's
exit-code assertion turns into a throw. Scoped to the process and restored afterwards; skipped on
a dry run, which never launches az. $null restores an unset variable to unset (not empty).
```
