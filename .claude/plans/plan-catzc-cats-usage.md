---
plan:
  status: active
  value: medium
  reviewed: 2026-10-27
  class: meta
  targets: [pwsh, contracts, go, python, js]
---

# catzc and cats usage: one name per role across code and yml

A map of every `catzc`/`cats` form in tracked code and yml (2026-10-27, about 15,850 hits in 11 categories) showed names that break
[PDR-CATS-CATZCISSOURCENAME](../../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-catzcissourcename) and
[PDR-CATS-ISPERSONNAME](../../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-ispersonname): `cats` inside identifiers, and
catzc-prefixed names left over from old disk names, where the current folder drops the namespace. Live names stay: `Catzc.` namespaces,
`contracts/catzc/`, `.catzc`, extension ids, git attribute classes, temp prefixes, and the test fixtures that mirror them (`Catzc.Widget`,
`catzc-widget`, `CATZC_WIDGET_ROOT`).

## Open questions

- Should `docs/drs/principles/cats-and-catzc.md` carry a short table of the live catzc forms (namespace, `contracts/catzc/`, `.catzc`,
  `CATZC_` env vars, extension ids, git attribute classes, mirrored fixtures), so the next cleanup reads one table instead of re-mapping
  15,850 hits? Recommended: yes, one table on the rule page; it shrinks the next session's map to the forms that are not in it.

## Open steps

- [ ] `cats` in identifiers (62 hits, 24 files): `Show-Cats`, `Get-CatsDrsIndex`, `Get-CatsDrsRules`, `Get-CatsDrsRuleIds`,
      `Get-CatsModules`, `Get-CatsRuleEnforcers`, `New-CatsCommandLookup`, `$catsAdrIndexCache`, `$catsAdrRuleIdsCache` take a catzc or
      unprefixed name, every caller in the same change. The renamed public files land by staged burst. Check: each renamed command's test
      file passes.
- [ ] `pwsh/Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1:49` adds the set `catzc-base-quality-gates`: compare it with the
      names `Get-ModuleGlobSet` returns for the real module; if the real set drops the prefix, rename it here and in
      `Get-ModuleProtectionIdentity.Tests.ps1`. Check: that test file passes.
- [ ] `.claude/plans/plan-idiomatic-names.md` lines 22 and 39 still name `catzc_diagrams`, `catzcbaserepository` and
      `python/Catzc.Diagrams/`; the folders on disk are `python/diagrams/` and `go/tests/baserepository/`. Rewrite those lines to the
      current names, or strike them if that plan's step has landed. Check: a Grep for `catzc_diagrams|catzcbaserepository` over the tree
      finds nothing.
- [ ] Decide `Verb-CatzcNoun` (1,290 hits: `Get-CatzcModulesFolder`, `Get-CatzcModuleRoot`, `Invoke-CatzcCommand`, …) and the glued
      identifiers (465 hits: `CatzcModulesRoot`, `__CatzcDeferredTypes`, `ForeignCatzcModule`, …) against
      [catzc-is-a-namespace](../../docs/drs/principles/cats-and-catzc.md): either a rule line saying a global or session-wide name keeps the
      prefix, or a rename plan for each group. Check: `Test-Plans` passes on the plan or rule page that records the decision.
