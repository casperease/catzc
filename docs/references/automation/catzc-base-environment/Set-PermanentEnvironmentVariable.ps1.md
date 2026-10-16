---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Set-PermanentEnvironmentVariable.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "05ffbb89e034"
---

# automation/Catzc.Base.Environment/Set-PermanentEnvironmentVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[System.Environment]::SetEnvironmentVariable($Name, [NullString]::Value, $Scope)`, written with `#`.

```text
PowerShell hands $null to a .NET string parameter as '', which the scopes the registry backs store as an empty value;
only a real null deletes it.
```
