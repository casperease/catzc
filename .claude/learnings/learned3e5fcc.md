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
- 2026-10-27 Cats: In hindsight I wish I knew this fact: a record's domain may cite only the domains drs.yml lists under its depends_on
  (design: external, principles, process; pwsh: no repository or configuration), so a merge or move must be checked against that list before
  a rule collapses into another domain
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Update-DrsCitation rewrites code files too, and importer-path .ps1 files and
  types/*.cs sources it touches must be held out of the live run and landed by Invoke-StagedBurst
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Invoke-CatzcCommand holds the Local catzc-run lock until its lease ends even after
  its task is stopped, so a stopped run blocks the next one
- 2026-10-27 Cats: In hindsight I wish I knew this fact: the user commits mid-burst, so a gate script must take changed files from recent
  commits, not from git diff of the working tree
- 2026-10-27 Cats: In hindsight I wish I knew this fact: a drone briefed with a whole domain stops at its 50-turn limit; under ten records
  or one merge group per drone finishes
- 2026-10-27 Cats: Token tip: run content-only drones that write rule-map rows, then one combined Update-DrsCitation, prefiltered with git
  grep to the files that name a retired code
- 2026-10-27 Cats: Token tip: brief drones with the domain dependency list and the importer-path hold rule up front instead of correcting
  them mid-run
