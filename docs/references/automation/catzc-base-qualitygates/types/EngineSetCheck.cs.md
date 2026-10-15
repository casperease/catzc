---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md
    kind: reference
    body_sha: "8f01a4ef78f3"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The engine-set check's settings (source-conventions.yml's engine_set) and its prose and C# matchers: the execution
engines are declared once, in the ExecutionEngines model, and never restated
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)). Beside the mode and the
exempt globs every source check has (SourceCheck), it reads two lists of phrase patterns, each a .NET regular
expression with a placeholder the matcher fills from the model, so no engine name or count is a literal here:
  count_phrases — '{count}' stands for a number word or digits; a match restates the engine count when its number is
                  not the model's count
  name_phrases  — '{name}' stands for any engine name; the matches of one phrase on one line restate the engine set
                  when they name two or more engines but not all of them (a pair joined by 'and', or bracketed test
                  titles that leave one engine out)
The defaults are empty lists, declared once here
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): the phrases themselves live
in the config. Matching ignores case. Property names mirror the YAML keys (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```

## comment:2

Above `public IReadOnlyList<(int Offset, string Text, string Message)>...`.

```text
Every place in a stretch of prose that restates the engine set, given the model's engine names. Each result is
the offset into the text, the matched text, and the message.
```

## comment:3

Above `public static IReadOnlyList<(int Offset, string Message)>...`.

```text
Every line of C# source that restates the engine set in code: two or more distinct engine names as string
literals on one line (an array or collection initializer, a chain of comparisons), where ExecutionEngines.Names
should be read. Each result is the offset of the line's first such literal and the message.
```
