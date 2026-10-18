# pwsh/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The source checks Test-SourceConventions runs beside its naming and one-function conventions
(configs/source-conventions.yml), and the single declaration of their sensible defaults
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)):
  engine_set    — the engine set is never restated: no literal engine list in code, no partial or miscounted engine
                  set in prose ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1));
                  an EngineSetCheck
  neutral_codes — a logic (L0) test's fixture data uses neutral ADR codes, never a code the ADR index declares
                  ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); a SourceCheck
An omitted check takes every default of its type: gate mode, nothing exempt, no phrases. Property names mirror the
YAML keys (snake_case, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```

## comment:2

Above `public SourceCheck track_root_literal { get; }`, written with `//`.

```text
The files that may spell the modules track's place, each with its reason; the analyzer rule NoTrackRootLiteral reads it
([ADR-AUTO-LAYERS](/docs/adr/automation/layers.md)).
```
