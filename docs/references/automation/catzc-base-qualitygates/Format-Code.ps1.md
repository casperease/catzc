---
catzc:
  immutable:
    with_body_sha: "2facff868b86"
    path: docs/references/automation/catzc-base-qualitygates/Format-Code.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: format-code-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-CONSOLE#10
---

# automation/Catzc.Base.QualityGates/Format-Code.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Write-Message "$verb $($pending.Count) $(@($engineGroup.Group |...`, written with `#`.

```text
Announce before the engine runs: a whole-repository pass takes seconds and prints nothing until it ends
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```

## comment:2

Above `if ($DryRun) {`, written with `#`.

```text
A file the engine left formatted is recorded; under -DryRun a file it would still change is not. Writing,
the engine has just formatted every file, so each is recorded under the key of its bytes now.
```

## comment:3

Above `$inScope = if ($Language) {`, written with `#`.

```text
Imprint steps run after every formatter, so a step never works on text a formatter is about to rewrite: a global step runs over
every language in scope, a language's own step over that language only.
```
