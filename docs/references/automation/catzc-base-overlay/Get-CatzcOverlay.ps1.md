---
catzc:
  immutable:
    with_body_sha: a6c28ba4602e
    repo_status: locked
    path: docs/references/automation/catzc-base-overlay/Get-CatzcOverlay.ps1.md
    folder: docs/references/automation/catzc-base-overlay
    name: get-catzc-overlay-ps1
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

# automation/Catzc.Base.Overlay/Get-CatzcOverlay.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$files = [string[]] @(Get-ChildPath $folder -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every
file of a consumer module is classified, so nothing is pruned.
```
