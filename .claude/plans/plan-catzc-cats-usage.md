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

- [ ] `docs/references/pwsh/base-docs/index.md`: its Division row of the ask-cats responsibility names the retired command name; it becomes
      `Show-Catzc`, the one caller the rename left to the front-page owner of that article. Check: `Test-Links` and `Format-Code` pass on
      that article.
- [ ] `Verb-CatzcNoun` (1,290 hits) and the glued identifiers (465 hits) are decided by
      [PDR-CATS-IDENTIFIERNAMESTHESYSTEM](../../docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-identifiernamesthesystem): the token
      stays where the noun names the system as against the repository or a consumer. Review the names one module at a time; a name whose
      noun means the same thing without the token takes the unprefixed name, every caller in the same change. Check: each reviewed module's
      test files pass.
