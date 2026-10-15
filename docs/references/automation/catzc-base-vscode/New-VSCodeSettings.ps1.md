---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md
    kind: comment-page
    body_sha: "1a7a082c236c"
---

# automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:7

Above `foreach ($key in ($MachineSetting.Keys | Sort-Object)) {`.

```text
Machine-resolved settings complete the authored ones, which win on a shared key; sorted, so the render is
stable.
```

## comment:8

Above `foreach ($id in ($LanguageFormatter.Keys | Sort-Object)) {`.

```text
Each language's editor formatter, merged into its [<id>] block (authored keys in the block win); sorted, so the
render is stable.
```
