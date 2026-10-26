# pwsh/Base.Drs/configs/drs-checks.yml

The settings of the ADR checks over the rule registries under `docs/drs/`, read through `DrsChecksConfig`.

## Keys

Every key is optional. An omitted key takes the sensible default declared once on `DrsChecksConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), so the
file states only what deviates.

- **`engine_neutrality`** — `Test-DrsEngineNeutrality`: the rule summaries of the listed `domains` carry no engine-specific syntax. `tokens`
  maps a kebab-case name to a case-sensitive .NET regex.
- **`citation_graph`** — `Test-DrsRegistry`: an ADR page cites only its own domain or a domain in its `depends_on`.
- **`dora_coverage`** — `Test-DrsRegistry`: each rule set has exactly one section linking its ADR in its domain's DORA file. `file` names
  that file, `exempt` maps a domain to the reason it keeps none, and `exempt_folders` maps a folder to the reason its ADRs take no section.
- **`code_language`** — the segment grammar of ADR codes and named rule headings.

## Modes

Each check has one `mode`, `gate` by default. In `report` mode a check prints every finding and their count and never fails the run. In
`gate` mode it fails the run like any quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). A check can ship in report mode
while its findings are worked off.

## Tokens

The `tokens` of `engine_neutrality` list engine-specific syntax a rule summary must not carry. Naming a catzc command (`Verb-Noun`) is
allowed, so only engine built-ins are listed.
