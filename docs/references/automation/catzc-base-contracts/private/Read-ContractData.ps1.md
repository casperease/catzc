---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Read-ContractData.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "2adefb665c7d"
---

# automation/Catzc.Base.Contracts/private/Read-ContractData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$PSCmdlet.WriteObject($data, $false)`, written with `#`.

```text
WriteObject without enumeration hands a top-level array over whole; Write-Output -NoEnumerate would wrap the
document in a list, since its input binds from the remaining arguments.
```
