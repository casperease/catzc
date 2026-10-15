---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepParameterEntryViolations.ps1.md
    kind: comment-page
    body_sha: a2f9c95dafdf
---

# automation/Catzc.Azure.Templates/private/Get-BicepParameterEntryViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `if ($Parameter.IsSecure) {`.

```text
A secure parameter takes its value from a Key Vault at deploy time. A literal is a secret in the repository;
say so without ever echoing it.
```
