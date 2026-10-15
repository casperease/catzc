---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-Prettier.ps1.md
    kind: comment-page
    body_sha: b7db04cbd3f1
    adrs:
      - ADR-PRIN-CONFIG#2
---

# automation/Catzc.Base.QualityGates/private/Invoke-Prettier.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)):
every file language languages.yml gives `formatter: prettier` is formatted here. Prettier picks its parser from
each file's extension and applies the root .prettierrc.yml and .editorconfig, so the Markdown and pipeline YAML
rules live in those files, not in a command per language.

`prettier --list-different` names the files that differ; without -DryRun, `prettier --write` then rewrites
exactly those. The files go to Prettier in batches that keep each command line short. Exit codes: 0 = clean,
1 = files differ (expected), anything higher is a tool error (a file Prettier cannot parse), which throws with
Prettier's own output.

Prettier must be on PATH — install it once with Install-Prettier.
```
