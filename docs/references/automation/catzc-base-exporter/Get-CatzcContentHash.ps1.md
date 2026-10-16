---
catzc:
  immutable:
    with_body_sha: "6ac5479d2df8"
    repo_status: locked
    path: docs/references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md
    folder: docs/references/automation/catzc-base-exporter
    name: get-catzc-content-hash-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$files = Get-ChildPath $rootFull -File -Depth 64 -Exclude @() -PruneVendor...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the hash
covers every file, so nothing is pruned and no depth drops one.
```
