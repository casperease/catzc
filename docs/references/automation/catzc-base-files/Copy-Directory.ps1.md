---
catzc:
  immutable:
    with_body_sha: a4effc39178e
    path: docs/references/automation/catzc-base-files/Copy-Directory.ps1.md
    folder: docs/references/automation/catzc-base-files
    name: copy-directory-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Files/Copy-Directory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($dir in Get-ChildPath $source -Directory -Depth 64 -Exclude @()...`, written with `#`.

```text
Recreate the directory structure first (so empty directories survive), then copy the files.
Each enumerated path starts with $source, so substring-after-prefix rebases it under $target
(safer than String.Replace, which would rewrite any other occurrence of the prefix).
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a copy
takes everything, so no name is pruned and no depth drops a file.
```
