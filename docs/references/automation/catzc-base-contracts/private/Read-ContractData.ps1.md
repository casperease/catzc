---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Read-ContractData.ps1.md
    kind: comment-page
    body_sha: "731366649c2e"
---

# automation/Catzc.Base.Contracts/private/Read-ContractData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$PSCmdlet.WriteObject($data, $false)`.

```text
WriteObject without enumeration hands a top-level array over whole; Write-Output -NoEnumerate would wrap the
document in a list, since its input binds from the remaining arguments.
```
