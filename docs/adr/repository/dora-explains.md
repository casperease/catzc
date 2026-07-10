# DORA explanations — repository

The `Dora explains` rationale for the ADRs in the `repository/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## Conventional folders — every folder in the repository, by convention (`ADR-REPO-FOLDERS`)

DORA's research into code maintainability and loosely coupled teams emphasizes clear structure and self-documenting boundaries; conventional
folders encode those boundaries into the filesystem so structure is enforced and visibility is instant.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — fixed structure is self-documenting and makes deviations
  visibly obvious.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — clear folder boundaries and tooling contracts decouple
  teams from coordination on naming.
- [Version control](https://dora.dev/capabilities/version-control/) — the single source of truth for structure is the repository layout
  itself, not a mapping file.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Dedicated output directory (`ADR-REPO-OUTDIR`)

DORA's research connects version control discipline to deployment predictability; separating source and output prevents dirty working trees
and makes CI artifact collection trivial and reliable.

- [Version control](https://dora.dev/capabilities/version-control/) — a clean working tree with no stray generated files keeps history and
  blame legible.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — centralizing output makes artifact collection deterministic
  and CI pipelines simple.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — the source/output distinction is structural and
  self-enforcing, not a style agreement.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Uniform formatting — the whole repository, one mechanical standard (`ADR-REPO-FORMAT`)

DORA's research on code maintainability and continuous delivery emphasizes clean diffs and reproducible builds; mechanical formatting
eliminates style noise from code review and ensures generated artifacts are byte-identical across runs, keeping blame and CI history
legible.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — automated formatting removes style noise and keeps
  `git blame` pointing at the author of logic, not reformatting.
- [Version control](https://dora.dev/capabilities/version-control/) — clean diffs containing only logic changes make code review sharp and
  history readable.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — canonical artifact generation ensures byte-identical output
  across builds, so CI diffs are trustworthy.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Versioned external API contracts and contract testing (`ADR-REPO-CONTRACT`)

DORA's research links test automation and continuous delivery to predictable deployment outcomes; contract testing applies these findings to
the public boundary, catching breaking changes in CI rather than in production.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — contract tests run in CI and gate breaking changes
  before merge.
- [Test automation](https://dora.dev/capabilities/test-automation/) — published contracts are verified mechanically by provider-side tests
  on every build.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — binding, tested contracts ensure external consumers stay
  deployable and unbroken across releases.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Generated READMEs — one authored source, linked out per conventional folder (`ADR-REPO-README`)

DORA's research on code maintainability and documentation quality emphasizes single sources of truth and automatic, drift-free maintenance;
linking READMEs to their authored sources ensures documentation is always current and prevents the divergence that hand-kept copies
introduce.

- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — single-sourced, automatically-linked documentation
  eliminates drift and keeps all channels current.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — filesystem links encode "one file, reachable from two paths"
  directly, removing an entire class of maintenance burden.
- [Version control](https://dora.dev/capabilities/version-control/) — no second copy means no mirror to drift from or to be mistaken for a
  second truth.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Generated root configs — every managed root file from one in-repo source of truth (`ADR-REPO-ROOTCFG`)

DORA's research on continuous delivery and code maintainability emphasizes reproducible, drift-free automation; centralizing root config
generation into one registry and one writer ensures every build produces byte-identical artifacts and config changes stay reviewable.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — idempotent generation with content-only comparison produces
  reproducible, byte-identical artifacts across builds.
- [Version control](https://dora.dev/capabilities/version-control/) — managed-file headers and the registry keep the source of truth
  explicit and drifts reviewable.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — one registry and one writer eliminate per-file drift logic
  and per-format special cases.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Documentation examples — the discovery theme (`ADR-REPO-EXAMPLE`)

DORA's research on learning culture and code maintainability emphasizes clear, consistent documentation; fictional example names make the
narrative legible and prevent confusion between illustration and production.

- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — consistent example names make documentation legible and
  trustworthy.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — clear, themed names make examples instantly recognizable as
  distinct from live data.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — accessible, coherent examples accelerate onboarding and reduce
  confusion.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Repo-wide variants — session-fixed settings behind `Test-`/`Assert-` primitives (`ADR-REPO-VARIANT`)

DORA's research on code maintainability and platform engineering emphasizes sensible defaults and low-ceremony guard mechanisms; typed
variant primitives (`Test-`/`Assert-`) make repo-wide decisions auditable and testable from anywhere, so the only stop condition is
mechanical, not procedural.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — typed guards instead of raw config reads make repo-wide
  decisions explicit and enforceable.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — zero-ceremony access to sensible defaults makes repo-wide
  settings usable as simple, one-liner guards everywhere.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — session-cached variants mean config is locked for the
  run and unchanged across parallel build steps.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Domain-language separation — three domains, three terminologies (`ADR-REPO-LANG`)

DORA's research on pervasive security and streamlining change approval emphasizes preventing configuration drift and production leaks; a
tag-aware AST gate that enforces domain boundaries catches silent violations where text-based checks cannot, so live identities never leak
into test code.

- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — mechanical enforcement prevents live identities from leaking
  into logic tests where they could cause production incidents.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — AST-based gates run on every build and fail with exact,
  actionable messages.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — semantic enforcement (not text-based) is what lets
  illustration remain legible while protecting the boundary.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
