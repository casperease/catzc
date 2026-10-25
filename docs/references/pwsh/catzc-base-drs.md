# Catzc.Base.Drs

The decision-record registry module. It owns `drs.yml`, the one source of the ADR domain structure: each domain, its role and the domains it
depends on, and each ADR's citation code ([drs-code-language](../../drs/repository/drs-code-language.md)). From it the module generates the
ADR index, resolves every citation to its ADR and rule, checks that the registry and the rule files agree, and rewrites citations when an
ADR moves. What it deliberately does **not** own is the ADRs themselves, which are authored under `docs/drs/`, nor the offline browser over
them, which is Show-Cats ([Catzc.Base.Docs](catzc-base-docs.md)).

## Responsibilities

| Responsibility   | Area      | Name                                                       |
| ---------------- | --------- | ---------------------------------------------------------- |
| responsibility:1 | registry  | [ADR registry](#responsibility1--adr-registry)             |
| responsibility:2 | gates     | [Registry checks](#responsibility2--registry-checks)       |
| responsibility:3 | citations | [Citation map](#responsibility3--citation-map)             |
| responsibility:4 | generate  | [Generated pages](#responsibility4--generated-pages)       |
| responsibility:5 | rewrite   | [Citation rewriting](#responsibility5--citation-rewriting) |

### responsibility:1 — ADR registry

The ADR domain structure as typed data. `drs.yml` declares each domain, its role and its `depends_on` domains, and each ADR's rule set with
its citation code; it loads through [Catzc.Base.Config](catzc-base-config.md) into one validated record, so a malformed entry or a cycle in
the domain graph fails when the registry loads, never in a reader. This responsibility returns the flat set of rule sets and the domain
dependency graph as typed edges, and renders that graph as a diagram or a table. The grammar of a code, the kinds the registry declares and
the segments a rule's code has at least, is one compiled form, so every reader and checker matches codes the same way
([ADR-REPO-DRSCODE](../../drs/repository/drs-code-language.md)).

### responsibility:2 — Registry checks

Keeping the registry and the ADR files in step. Two quality gates
([ADR-AUTO-TEST-QUALITYGATE](../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) check it. The registry check finds
exactly one rule file per registered rule set, headed by its registered code, and no rule file left unregistered; it also checks that an ADR
page cites only its own domain or one it depends on, that every rule set outside an exempt ADR domain is explained once in its domain's DORA
file, and that every code and rule heading follows the code language. The engine-neutrality check confirms that the rule summaries of the
configured ADR domains state a rule, never one engine's syntax
([ADR-AUTO-ENGINE-THREEENGINES](../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)). Each check's mode, a failure
or a report, is configured in `drs-checks.yml`.

### responsibility:3 — Citation map

Resolving a citation. This responsibility reads the rule-citation registry in the [ADR index](../../drs/index.md) into one entry per ADR,
reads the rules of one ADR file, and builds the citation map every reference resolves through: each code to its ADR's path and declared
rules, and the flat set of every declared rule id. A checker that validates a citation, and the browser that shows one, read this one map.

### responsibility:4 — Generated pages

The pages derived from the registry, reproduced on every import. The ADR index is generated from `drs.yml` and the index's own text in
`drs-index.yml`; the spell checker's word list of ADR code segments is generated from the registry and the rule headings, so a rule's
spelled-out name is never a hand-written terminology entry. Both are written only when they change, and a stale one is a finding of
`Test-GeneratedFiles` ([Catzc.Base.QualityGates](catzc-base-quality-gates.md)).

### responsibility:5 — Citation rewriting

Moving, renaming or splitting an ADR. A code map and a rule map say what moved, and this responsibility rewrites one file's references to
match: rule codes, other codes of a registered kind, rule anchors, link destinations into `docs/drs/`, and plain path mentions. It writes
the file only when something changed and reports each change with its kind, line, old text and new text.

## What the module does

The module's core is the registry: one authored file states the ADR domains, their dependencies and every ADR's code, and everything else
the module does is read or derived from it. The index a reader opens is generated from it, the citation map a checker resolves through is
built from that index and the rule headings, and the quality gates hold the rule files to it, so a registry entry without its file, a file
without its entry, or a citation outside its domain's dependencies is found by a gate rather than by a reader.

The code grammar sits under all of it. A code is a path of named segments, and the kinds and rule depths come from the registry, so the
gates, the citation map, the rewriter and the spell checker's word list all match one form. When an ADR moves, the rewriter carries every
citation, anchor and link across with it, one file at a time, which keeps the tree at one living version of each reference.

## Division

The module's public surface, sorted into the responsibilities above.

| Responsibility                        | Function                     |
| ------------------------------------- | ---------------------------- |
| responsibility:1 — ADR registry       | `Get-DrsRuleSet`             |
|                                       | `Get-DrsDomainEdges`         |
|                                       | `ConvertTo-DrsDomainDiagram` |
| config                                | `drs.yml`                    |
| responsibility:2 — Registry checks    | `Test-DrsRegistry`           |
|                                       | `Test-DrsEngineNeutrality`   |
| config                                | `drs-checks.yml`             |
| responsibility:3 — Citation map       | `Get-CatsDrsIndex`           |
|                                       | `Get-CatsDrsRules`           |
|                                       | `Get-CatsDrsRuleIds`         |
|                                       | `Get-DrsCitationMap`         |
| responsibility:4 — Generated pages    | `Build-DrsIndex`             |
|                                       | `Build-DrsCodeDictionary`    |
| config                                | `drs-index.yml`              |
| responsibility:5 — Citation rewriting | `Update-DrsCitation`         |
