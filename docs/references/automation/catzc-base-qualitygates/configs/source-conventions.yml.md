---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/source-conventions.yml.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b5b1dc793a03
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-ENGINE#{1,6}
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/configs/source-conventions.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `engine_set:`, written with `#`.

```text
The source checks Test-SourceConventions runs beside its naming conventions. Each check takes:
  mode    gate (default: every finding fails the run) or report (findings are listed as a work list and never fail
          it); a check reports only while its work list is drained, and returns to gate once its count is 0
  exempt  repository-relative glob -> why its files are left out; default none
Every key is optional: an omitted key takes the sensible default declared once on
Catzc.Base.QualityGates.SourceConventionsConfig
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
```

## comment:2

Above `engine_set:`, written with `#`.

```text
The engine set is declared once, in the ExecutionEngines model, and never restated
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)). The engine names and their
count are read from the model, so the phrases below are .NET regular expressions with placeholders:
  count_phrases  {count} is a number word or digits; a match whose number is not the model's count is a finding
  name_phrases   {name} is any engine name; one phrase's matches on one line that name two or more engines, but not
                 all of them, are a finding
The term "POSIX engines" ([ADR-AUTO-ENGINE#6](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine6)) is
derived from the model and carries neither a count nor an engine name, so no phrase matches it.
Defaults: no phrases.
```

## comment:3

Above `neutral_codes:`, written with `#`.

```text
A logic (L0) test's fixture data uses neutral ADR codes, never one the ADR index declares
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
