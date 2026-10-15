---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Copy-Directory.ps1.md
    kind: comment-page
    body_sha: f4867f8718e8
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Files/Copy-Directory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `foreach ($dir in Get-ChildPath $source -Directory -Depth 64 -Exclude @()...`.

```text
Recreate the directory structure first (so empty directories survive), then copy the files.
Each enumerated path starts with $source, so substring-after-prefix rebases it under $target
(safer than String.Replace, which would rewrite any other occurrence of the prefix).
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a copy
takes everything, so no name is pruned and no depth drops a file.
```
