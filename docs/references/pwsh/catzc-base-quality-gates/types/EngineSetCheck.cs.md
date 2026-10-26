# pwsh/Base.QualityGates/types/EngineSetCheck.cs

The settings of the engine-set check (`engine_set` in `source-conventions.yml`) and its prose and C# matchers. The execution engines are
declared once, in the `ExecutionEngines` model, and never restated
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)). So no engine name or
count is a literal here: each phrase is a .NET regular expression with a placeholder the matcher fills from the model.

## Keys

Beside the mode and the exempt globs every source check has (`SourceCheck`), it reads two lists of phrase patterns:

- **`count_phrases`** — `{count}` stands for a number word or digits. A match restates the engine count when its number is not the model's
  count.
- **`name_phrases`** — `{name}` stands for any engine name. The matches of one phrase on one line restate the engine set when they name two
  or more engines but not all of them, such as a pair joined by "and", or bracketed test titles that leave one engine out.

The defaults are empty lists, declared once here
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)); the
phrases live in the config. Matching ignores case. Property names mirror the YAML keys, snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Matchers

The prose matcher returns every place in a stretch of prose that restates the engine set, given the model's engine names. Each result is the
offset into the text, the matched text and the message.

The C# matcher returns every line of source that restates the engine set in code: two or more distinct engine names as string literals on
one line, such as an array or collection initializer or a chain of comparisons, where `ExecutionEngines.Names` should be read. Each result
is the offset of the line's first such literal and the message.
