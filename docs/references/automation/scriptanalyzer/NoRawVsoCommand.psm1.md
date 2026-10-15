---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoRawVsoCommand.psm1.md
    kind: comment-page
    body_sha: "18c7dd4fee8a"
    adrs:
      - ADR-PIPE-VAR#1
    links: []
---

# automation/.scriptanalyzer/NoRawVsoCommand.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Azure DevOps pipeline variables and logging are driven by ##vso[task.…]
logging commands written to stdout. These strings are awkward and error-prone
(silent name rewrites, forgotten flags, no validation), so they must never be
written directly. Use the canonical setter Set-AdoPipelineVariable, which
validates names, handles output/secret flags, logs, and no-ops outside a
pipeline.

This rule flags any string literal containing '##vso[task.' that appears
OUTSIDE the function Set-AdoPipelineVariable. The canonical setter is the one
sanctioned place that emits the raw command, so it is exempt.

See ADR: [ADR-PIPE-VAR#1](/docs/adr/pipelines/pipeline-variables.md#rule-adr-pipe-var1).
```

## comment:2

Above `$vsoPattern = '##vso\s*\[\s*task\.'`.

```text
Pattern for the raw logging command. Matches '##vso[task.' with optional
whitespace, e.g. ##vso[task.setvariable …] or ##vso[task.logissue …].
```
