# pwsh/Base.Drs/configs/drs-checks.yml

The settings of the DRS checks over the rule registries under `docs/drs/`, read through `DrsChecksConfig`.

## Keys

Every key is optional. An omitted key takes the sensible default declared once on `DrsChecksConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), so the
file states only what deviates.

- **`engine_neutrality`** — `Test-DrsEngineNeutrality`: the rule summaries of each domain under `domains` carry none of the tokens of the
  sets it names. `token_sets` maps a kebab-case set name to a map of kebab-case token name to a case-sensitive .NET regex.
- **`citation_graph`** — `Test-DrsRegistry`: a record page cites only its own domain or a domain in its `depends_on`.
- **`dora_coverage`** — `Test-DrsRegistry`: each rule set has exactly one section linking its record in its domain's DORA file. `file` names
  that file, `exempt` maps a domain to the reason it keeps none, and `exempt_folders` maps a folder to the reason its records take no
  section.
- **`code_language`** — the segment grammar of rule codes and named rule headings.

## Modes

Each check has one `mode`, `gate` by default. In `report` mode a check prints every finding and their count and never fails the run. In
`gate` mode it fails the run like any quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). A check can ship in report mode
while its findings are worked off.

## Tokens

The `engine` set lists engine-specific syntax a rule summary must not carry; naming a catzc command (`Verb-Noun`) is allowed, so only engine
built-ins are listed. The `vendor` set lists vendor names a vendor-neutral tier must not carry; a vendor's own domain is never held to it. A
tier is brought under the gate by one `domains` line naming the sets that fit it, once its records are clean.
