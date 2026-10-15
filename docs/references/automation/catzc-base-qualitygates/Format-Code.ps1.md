---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-Code.ps1.md
    kind: comment-page
    body_sha: "5b3f8d25018f"
    adrs:
      - ADR-AUTO-CONSOLE#10
---

# automation/Catzc.Base.QualityGates/Format-Code.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `Write-Message "$verb $($pending.Count) $(@($engineGroup.Group |...`.

```text
Announce before the engine runs: a whole-repository pass takes seconds and prints nothing until it ends
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```

## comment:7

Above `if ($DryRun) {`.

```text
A file the engine left formatted is recorded; under -DryRun a file it would still change is not. Writing,
the engine has just formatted every file, so each is recorded under the key of its bytes now.
```

## comment:8

Above `$inScope = if ($Language) {`.

```text
Imprint steps run after every formatter, so a step never works on text a formatter is about to rewrite: a global step runs over
every language in scope, a language's own step over that language only.
```
