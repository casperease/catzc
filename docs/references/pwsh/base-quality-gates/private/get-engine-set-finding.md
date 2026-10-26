# pwsh/Base.QualityGates/private/Get-EngineSetFinding.ps1

The engine-set check of Test-SourceConventions: it lists every place one file restates the set of execution engines instead of reading it
from the model. The engine names and their count come from the caller, so nothing here names an engine.

## help

### synopsis

Lists every place one file restates the engine set instead of reading it from the model.

### description

The engine-set check of Test-SourceConventions
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)): the execution engines
are declared once, in `[Catzc.Base.Engines.ExecutionEngines]`, and every other list is read from it. The engine names and their count come
from the caller, read from that model, so nothing here names an engine.

In prose — a markdown file's text, and the comments (help included) of a code file (CommentLexer) — a phrase from engine_set's count_phrases
or name_phrases that miscounts the engines or names some but not all of them (EngineSetCheck.FindProse). In code:

- PowerShell (from its syntax tree): a ValidateSet, an array literal, or a switch with no default whose string values name two or more
  engines;
- C#: two or more engine names as string literals on one line (EngineSetCheck.FindCSharpLists).

### parameter `Path`

The file's repository-relative, '/'-separated path, which leads each finding.

### parameter `Text`

The file's text.

### parameter `Ast`

The file's PowerShell syntax tree, when it is a PowerShell file (parsed once by the caller).

### parameter `EngineName`

The model's engine names (`[Catzc.Base.Engines.ExecutionEngines]::Names`).

### parameter `Check`

The engine-set check's settings (source-conventions.yml engine_set).

### outputs

`[string[]]` One '`<path>:<line>`: `<message>`' per finding, in line order.
