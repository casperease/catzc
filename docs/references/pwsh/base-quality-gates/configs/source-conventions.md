# pwsh/Base.QualityGates/configs/source-conventions.yml

The settings for the source checks that Test-SourceConventions runs beside its naming conventions.

## Keys

Every key is optional. An omitted key takes the sensible default declared once on `Catzc.Base.QualityGates.SourceConventionsConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). Each
check takes:

- `mode`: `gate`, the default, where every finding fails the run, or `report`, where findings are listed as a work list and never fail it. A
  check reports only while its work list is drained, and returns to `gate` once its count is 0.
- `exempt`: a repository-relative glob mapped to the reason its files are left out. Default: none.

## engine_set

The engine set is declared once, in the ExecutionEngines model, and never restated
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)). The engine names and
their count are read from the model, so the phrases are .NET regular expressions with placeholders:

- `count_phrases`: `{count}` is a number word or digits. A match whose number is not the model's count is a finding.
- `name_phrases`: `{name}` is any engine name. A line where one phrase's matches name two or more engines, but not all of them, is a
  finding.

The term "POSIX engines"
([ADR-AUTO-ENGINE-IMPORTERENTRY](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-importerentry)) is derived from the
model and carries neither a count nor an engine name, so no phrase matches it. Default: no phrases.

## neutral_codes

A logic (L0) test's fixture data uses neutral ADR codes, never one the ADR index declares
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). Its `exempt` entries
name the tests that must assert a real rule's exact message.
