---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e126a3782264
---

# automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($key in ($MachineSetting.Keys | Sort-Object)) {`, written with `#`.

```text
Machine-resolved settings complete the authored ones, which win on a shared key; sorted, so the render is
stable.
```

## comment:2

Above `foreach ($id in ($LanguageFormatter.Keys | Sort-Object)) {`, written with `#`.

```text
Each language's editor formatter, merged into its [<id>] block (authored keys in the block win); sorted, so the
render is stable.
```
