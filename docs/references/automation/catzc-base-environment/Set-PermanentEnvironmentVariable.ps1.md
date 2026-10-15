---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Set-PermanentEnvironmentVariable.ps1.md
    kind: comment-page
    body_sha: ac0bdf5083a6
---

# automation/Catzc.Base.Environment/Set-PermanentEnvironmentVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `[System.Environment]::SetEnvironmentVariable($Name, [NullString]::Value, $Scope)`.

```text
PowerShell hands $null to a .NET string parameter as '', which the scopes the registry backs store as an empty value;
only a real null deletes it.
```
