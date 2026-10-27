# Session learnings 3e5fcc

Started 2026-10-27T09:07:37.7185717+01:00.

- 2026-10-27 Cats: In hindsight I wish I knew this fact: the widget/gadget test fixtures carry Catzc. and CATZC_ on purpose, because the
  code under test filters on those prefixes.
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Test-Glossary (96) and Test-Terminology (3) already fail on main for reasons
  unrelated to catzc naming.
- 2026-10-27 Cats: Token tip: Next time, save tokens by: grouping the hits by token form and checking against disk names in one script,
  before planning any edits.
- 2026-10-27 Cats: Token tip: Next time, save tokens by: reading three hits of a category in context before accepting a heuristic category
  as a fix list.
- 2026-10-27 Cats: In hindsight I wish I knew this fact: a DRS reviewer agent covers about 80k tokens of records per pass, so a 300k-word
  domain needs a slice of under 10 records per agent
- 2026-10-27 Cats: In hindsight I wish I knew this fact: the DRS biggest bloat is tier misplacement — flow/ carries ADO and pwsh mechanics,
  automation/ names cmdlets in rule text — which Test-DrsEngineNeutrality does not catch in flow/, design/ or thesis/
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Test-Plans requires a ## Open steps section of checkbox steps, each naming its
  check; numbered ## sections fail ADR-REPO-PLANS-ONESHAPE
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Format-Code on markdown turns a bare FDR-DETECT-* glob into an emphasis underscore,
  so plan text names rule families without a trailing star
- 2026-10-27 Cats: In hindsight I wish I knew this fact: several DRS records still contradicted each other (generated-head keys, plan
  location, prod approval, landing-zone policy count) and no gate cross-checks rule pairs
- 2026-10-27 Cats: Token tip: brief DRS review agents with a fixed file list of under 10 records instead of a whole domain, so no agent
  stops mid-slice and needs a resume
- 2026-10-27 Cats: Token tip: write a plan in the plans shape (## Open steps, checkbox plus Check) from the start instead of reshaping it
  after Test-Plans fails
