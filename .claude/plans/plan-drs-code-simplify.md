---
plan:
  status: active
  value: high
  reviewed: 2026-10-26
  class: Meta
  targets:
    [
      docs/drs/repository/drs-code-language.md,
      pwsh/Base.Drs/configs/drs.yml,
      pwsh/Base.Drs/private/Get-DrsCodeLanguageViolations.ps1,
      docs/drs,
    ]
---

# DRS code simplify

## Why its value

Every code is read, cited and searched constantly, so it must be easy to see and remember, unique in the repository, show its source, and
compact without losing its identity. Today rule names run to 73 characters, 19 rule names repeat across records, records nest in records,
and external guidance (CAF, WAF, DORA, the Agile Manifesto, lean theory, Pester) sits under catzc's own kinds.

## Decided

- **Capitalization on**: every segment upper case, set once as `code_language.capitalization` in `pwsh/Base.Drs/configs/drs-checks.yml`.
- **Length budget**: a rule name is at most 24 characters (`code_language.max_rule_chars`), held by `Test-DrsCode -Rule`.
- **Unique rule names**: every rule name is unique in the repository, so `Format-DrsCode` compacts a code to record plus rule, kind plus
  rule, or rule alone without losing its identity; prose keeps the full code (`ADR-REPO-LINK-ONECITATIONSPELLING`).
- **Fixed positions**: kind, domain where the kind is shared, record, rule; no record nests in a record (`FDR-LIFE-DISCARDISTERMINAL`).
- **EDR kind**: every external source is an EDR record, by kind swap only, so the code keeps its source path
  (`EDR-PWSH-PESTER-PESTERFRAMEWORK`, `EDR-AZ-CAF-GOV-R01`, `EDR-DORA-CI-EVERYCOMMITBUILDS`, `EDR-LEAN-SEVENWASTES`). An EDR rule states how
  catzc reads the source and how it binds to the other records, with a `source:` line; catzc's own decision stays in the ADR or PDR that
  cites it. `RDR` is retired. `ADR-ADO-*` and `ADR-AZ-CLI` stay catzc's own decisions.
- **Native ids outside**: an external item keeps the source's id (`EDR-AZ-WAF-RE-RE01`), a CAF rule its item number in its record
  (`EDR-AZ-CAF-GOV-R01`); named, not numbered, binds catzc's own rules only.
- **Future names only**: the generator `out/drs-rename-map-fd7758d1.ps1` holds the hand names and writes the one-shot map through
  `ConvertTo-DrsCode`; a word is dropped only where cspell's English dictionary proves the boundary. The map is applied once and deleted;
  the tree keeps only the future names.

## Open steps

- [ ] `docs/drs/repository/drs-code-language.md`: rewrite `ADR-REPO-DRSCODE` for the capitalization setting, the length budget, unique rule
      names, fixed positions, native ids for external items, the EDR kind and the retired RDR kind (check: `Test-DrsRegistry`)
- [ ] `pwsh/Base.Drs/configs/drs.yml`: register the `EDR` kind and retire `RDR` (check: `Test-DrsRegistry`)
- [ ] `out/drs-rule-map.tsv`: regenerate with `out/drs-rename-map-fd7758d1.ps1`, then apply it once with `Update-DrsCitation` while no peer
      edits DRS files (check: `Test-DrsRegistry`, `Test-Links`, `Test-Spelling`)
- [ ] `docs/drs/azure/caf/`: move each CAF record to `docs/drs/external/`, one record at a time (check: `Test-Links` on the moved file)
- [ ] `docs/drs/azure/waf/`: move each WAF record to `docs/drs/external/`, one record at a time (check: `Test-Links` on the moved file)
- [ ] `docs/drs/research/`: move each DORA record to `docs/drs/external/`, one record at a time (check: `Test-Links` on the moved file)
- [ ] `docs/drs/process/`: move the agile, values, agile-principles and lean records to `docs/drs/external/` (check: `Test-Links` on each
      moved file)
- [ ] each EDR record under `docs/drs/external/`: rewrite its rules to how catzc reads the source, with a `source:` line, moving catzc's
      decisions into the ADR or PDR that cites it, one record at a time (check: `Test-DrsRegistry`)
- [ ] `pwsh/Base.Drs/private/Get-DrsCodeLanguageViolations.ps1`: hold every rule heading to `Test-DrsCode -Rule` and every rule name to
      repository-wide uniqueness, after the rename so the gate lands green (check: `Test-DrsRegistry`)

## Refs

- `docs/drs/repository/drs-code-language.md` (`ADR-REPO-DRSCODE`)
- `pwsh/Base.Drs/` (`Test-DrsCode`, `Assert-DrsCode`, `Format-DrsCode`, `ConvertTo-DrsCode`)
- `out/drs-rename-review.md` (26 dropped-word renames to read)
