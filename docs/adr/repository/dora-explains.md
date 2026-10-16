---
catzc:
  derived:
    path: docs/adr/repository/dora-explains.md
    folder: docs/adr/repository
    name: dora-explains
    filetype: md
    kind: adr
    language: markdown
    track: docs
    body_sha: "25f6f76e79b8"
    links:
      - docs/adr/repository/agent-definitions.md
      - docs/adr/repository/api-contracts.md
      - docs/adr/repository/code-file-meta.md
      - docs/adr/repository/comments-in-docs.md
      - docs/adr/repository/controlled-vocabulary.md
      - docs/adr/repository/conventional-folders.md
      - docs/adr/repository/dedicated-output-directory.md
      - docs/adr/repository/documentation-examples.md
      - docs/adr/repository/domain-language-separation.md
      - docs/adr/repository/file-meta.md
      - docs/adr/repository/function-help.md
      - docs/adr/repository/generated-readmes.md
      - docs/adr/repository/generated-root-configs.md
      - docs/adr/repository/inspiration.md
      - docs/adr/repository/markdown-links.md
      - docs/adr/repository/output-formats.md
      - docs/adr/repository/protected-globs.md
      - docs/adr/repository/repo-variants.md
      - docs/adr/repository/uniform-formatting.md
      - docs/references/dora/capabilities.md#ai-accessible-internal-data
      - docs/references/dora/capabilities.md#clear-and-communicated-ai-stance
      - docs/references/dora/capabilities.md#code-maintainability
      - docs/references/dora/capabilities.md#continuous-delivery
      - docs/references/dora/capabilities.md#continuous-integration
      - docs/references/dora/capabilities.md#documentation-quality
      - docs/references/dora/capabilities.md#learning-culture
      - docs/references/dora/capabilities.md#loosely-coupled-teams
      - docs/references/dora/capabilities.md#pervasive-security
      - docs/references/dora/capabilities.md#platform-engineering
      - docs/references/dora/capabilities.md#team-experimentation
      - docs/references/dora/capabilities.md#test-automation
      - docs/references/dora/capabilities.md#version-control
      - docs/references/dora/capabilities.md#working-in-small-batches
      - docs/references/dora/index.md
---

# DORA explanations — repository

The `Dora explains` rationale for the ADRs in the `repository/` domain, consolidated in one place. Each entry names its ADR and rule code,
then reproduces that ADR's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The decisions
live in the ADRs themselves; this file carries only their DORA rationale.

## Conventional folders

`Conventional folders — every folder in the repository, by convention`

[ADR-REPO-FOLDERS](conventional-folders.md)

> DORA's research into code maintainability and loosely coupled teams emphasizes clear structure and self-documenting boundaries;
> conventional folders encode those boundaries into the filesystem so structure is enforced and visibility is instant.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — fixed structure is self-documenting and makes
  deviations visibly obvious.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — clear folder boundaries and tooling contracts
  decouple teams from coordination on naming.
- [Version control](../../references/dora/capabilities.md#version-control) — the single source of truth for structure is the repository
  layout itself, not a mapping file.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Output directory

`Dedicated output directory`

[ADR-REPO-OUTDIR](dedicated-output-directory.md)

> DORA's research connects version control discipline to deployment predictability; separating the source and the output prevents dirty
> working trees and makes CI artifact collection trivial and reliable.

- [Version control](../../references/dora/capabilities.md#version-control) — a clean working tree with no stray generated files keeps
  history and blame legible.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — centralizing output makes artifact collection
  deterministic and CI pipelines simple.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — the source/output distinction is structural and
  self-enforcing, not a style agreement.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Output formats

`Output formats — one catalogue of what lands under the output root`

[ADR-REPO-OUTFMT](output-formats.md)

> DORA's research ties fast, reliable delivery to fast feedback; a declared, validated shape for every output file turns a broken report or
> drawing into a named failure at the moment it is written, not a surprise when a person opens it.

- [Test automation](../../references/dora/capabilities.md#test-automation) — every output format carries a validator that runs as code, so a
  malformed file fails a check instead of a review.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — deterministic, re-runnable producers make every output
  reproducible from its inputs.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Uniform formatting

`Uniform formatting — the whole repository, one mechanical standard`

[ADR-REPO-FORMAT](uniform-formatting.md)

> DORA's research on code maintainability and continuous delivery emphasizes clean diffs and reproducible builds; mechanical formatting
> eliminates style noise from code review and ensures generated artifacts are byte-identical across runs, keeping blame and CI history
> legible.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — automated formatting removes style noise and keeps
  `git blame` pointing at the author of logic, not reformatting.
- [Version control](../../references/dora/capabilities.md#version-control) — clean diffs containing only logic changes make code review
  sharp and history readable.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — canonical artifact generation ensures byte-identical
  output across builds, so CI diffs are trustworthy.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## API contracts

`Versioned external API contracts and contract testing`

[ADR-REPO-CONTRACT](api-contracts.md)

> DORA's research links test automation and continuous delivery to predictable deployment outcomes; contract testing applies these findings
> to the public boundary, catching breaking changes in CI rather than in production.

- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — contract tests run in CI and block breaking
  changes before merge.
- [Test automation](../../references/dora/capabilities.md#test-automation) — published contracts are verified mechanically by provider-side
  tests on every build.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — binding, tested contracts ensure external consumers
  stay deployable and unbroken across releases.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Generated READMEs

`Generated READMEs — one authored source, copied out per conventional folder with its links rebased`

[ADR-REPO-README](generated-readmes.md)

> DORA's research on code maintainability and documentation quality emphasizes single sources of truth and automatic, drift-free
> maintenance; generating READMEs from their authored sources on every import keeps documentation current, readable where it is opened, and
> free of the divergence that hand-kept copies introduce.

- [Documentation quality](../../references/dora/capabilities.md#documentation-quality) — single-sourced, regenerated documentation whose
  links work from every folder it appears in.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — the README is generated, never edited, so one
  authored article is the whole maintenance burden.
- [Version control](../../references/dora/capabilities.md#version-control) — only the source is committed; the generated copy is never
  mistaken for a second truth.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Generated root configs

`Generated root configs — every managed root file from one in-repo source of truth`

[ADR-REPO-ROOTCFG](generated-root-configs.md)

> DORA's research on continuous delivery and code maintainability emphasizes reproducible, drift-free automation; centralizing root config
> generation into one registry and one writer ensures every build produces byte-identical artifacts and config changes stay reviewable.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — idempotent generation with content-only comparison
  produces reproducible, byte-identical artifacts across builds.
- [Version control](../../references/dora/capabilities.md#version-control) — managed-file headers and the registry keep the source of truth
  explicit and drifts reviewable.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — one registry and one writer eliminate per-file drift
  logic and per-format special cases.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Documentation examples

`Documentation examples — the discovery theme`

[ADR-REPO-EXAMPLE](documentation-examples.md)

> DORA's research on learning culture and code maintainability emphasizes clear, consistent documentation; fictional example names make the
> narrative legible and prevent confusion between illustration and production.

- [Documentation quality](../../references/dora/capabilities.md#documentation-quality) — consistent example names make documentation legible
  and trustworthy.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — clear, themed names make examples instantly
  recognizable as distinct from live data.
- [Learning culture](../../references/dora/capabilities.md#learning-culture) — accessible, coherent examples accelerate onboarding and
  reduce confusion.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Repo-wide variants

`Repo-wide variants — session-fixed settings behind Test-/Assert- primitives`

[ADR-REPO-VARIANT](repo-variants.md)

> DORA's research on code maintainability and platform engineering emphasizes sensible defaults and low-ceremony guard mechanisms; typed
> variant primitives (`Test-`/`Assert-`) make repo-wide decisions auditable and testable from anywhere, so the only stop condition is
> mechanical, not procedural.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — typed guards instead of raw config reads make
  repo-wide decisions explicit and enforceable.
- [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — zero-ceremony access to sensible defaults makes
  repo-wide settings usable as simple, one-liner guards everywhere.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — session-cached variants mean config is locked for
  the run and unchanged across parallel build steps.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Language-zone separation

`Language-zone separation — three zones, three terminologies`

[ADR-REPO-LANG](domain-language-separation.md)

> DORA's research on pervasive security and streamlining change approval emphasizes preventing configuration drift and production leaks; a
> tag-aware AST quality gate that enforces the zone boundaries catches silent violations where text-based checks cannot, so live identities
> never leak into test code.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — mechanical enforcement prevents live identities from
  leaking into logic tests where they could cause production incidents.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — AST-based quality gates run on every build and
  fail with exact, actionable messages.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — semantic enforcement (not text-based) is what lets
  illustration remain legible while protecting the boundary.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Controlled vocabulary

`Controlled vocabulary — one definition per term, opt-in glossary sources`

[ADR-REPO-VOCAB](controlled-vocabulary.md)

> DORA's research on documentation quality finds that accurate, well-organized internal documentation amplifies every other technical
> capability; a term that means one thing everywhere, anchored on the rule that defines it and contrasted with its neighbours, is what keeps
> that documentation accurate as it grows, and an in-repository glossary keeps it versioned and checked like the code.

- [Documentation quality](../../references/dora/capabilities.md#documentation-quality) — one definition per term, with its differences from
  similar terms spelled out, keeps every ADR, help text, and message consistent.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a shared, enforced vocabulary lets anyone read and
  change any part of the codebase without relearning private meanings.
- [AI-accessible internal data](../../references/dora/capabilities.md#ai-accessible-internal-data) — an in-repository, structured glossary
  is internal knowledge an assistant can read and apply exactly, rather than guess from usage.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Markdown links

`Markdown links — relative in documents, repository-rooted out of code`

[ADR-REPO-LINK](markdown-links.md)

> DORA's research on documentation quality finds that documentation helps only while it is accurate and findable; a pointer from code to the
> decision behind it is documentation too, and a pointer that silently rots — a bare path to a moved ADR, a citation of a renumbered rule —
> sends the reader to the wrong rationale or none. Checking every link and deriving each code link from its citation keeps those pointers
> true as the documents move.

- [Documentation quality](../../references/dora/capabilities.md#documentation-quality) — every link from code and between documents
  resolves, so the documentation a reader follows is the documentation that exists.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a comment that links the rule it implements lets
  anyone changing the code find the reason for it in one step.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Comments in docs

`Comments in docs — one insight line in the file, the prose in its comment page`

[ADR-REPO-COMMENTS](comments-in-docs.md)

> DORA's research on documentation quality finds that documentation helps when it is accurate, findable, and kept where readers look for it;
> long prose buried between statements is reviewed as code and read only by whoever opens that file. Moving it, verbatim, to a page beside
> the module's reference article, and leaving one line of insight and a checked link in the code, keeps both the code and its explanation
> easy to read.

- [Documentation quality](../../references/dora/capabilities.md#documentation-quality) — the prose lives in one findable place, rendered and
  reviewed as documentation, and a gate keeps every comment and its page paired.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a file shows its code and the one fact the code does
  not say, so a change is made against what matters.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## File meta

`File meta — one block of derived facts, in the carrier each kind of file has`

[ADR-REPO-FILEMETA](file-meta.md)

> DORA's research ties maintainable systems to a single source of truth and to checks that catch drift early. Computable facts written by a
> formatter in one fixed form, and authored values stated once beside the thing they describe, keep files and registries from drifting apart
> without a manual step.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a fact is stated once, so a file and the registry
  that mirrors it cannot disagree.
- [Version control](../../references/dora/capabilities.md#version-control) — derived values are byte-identical on every run, so a diff
  carries only real change.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — the meta check fails a drifted file in the
  pipeline, before it reaches the trunk.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Code file meta

`Code file meta — a derived head in the first comment of a C# type file and a PowerShell function file`

[ADR-REPO-CODEMETA](code-file-meta.md)

> DORA's research finds that code which shows its place and tier at a glance is easier to change safely, and that a fact a tool writes
> cannot go stale the way a typed one does. A head that changes only when a file moves or changes tier adds no noise to a change.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a file states its path, module and tier at the top,
  so a reader changes it with its place in view.
- [Version control](../../references/dora/capabilities.md#version-control) — the head holds no hash of the body, so an edit stays one hunk
  and concurrent edits do not conflict on it.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Function help

`Function help — one normal form for the help block of a PowerShell function file`

[ADR-REPO-HELP](function-help.md)

> DORA's research ties maintainable code to documentation that is stated once and kept where the reader looks for it. A help block with one
> section order, one place for its citations and one description per parameter lets a reader and a tool find each fact the same way in every
> file, and shows a difference between two descriptions instead of hiding it.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a parameter is described once, so two descriptions
  cannot disagree unseen.
- [Version control](../../references/dora/capabilities.md#version-control) — citations are a sorted list, so two edits that add one do not
  conflict on its order.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Agent definitions

`Agent definitions — every sub-agent rests on a rule and maps to its checks`

[ADR-REPO-AGENTS](agent-definitions.md)

> DORA's AI research finds that AI assistance pays off when the organization's stance on its use is clear and communicated, and when the
> tools work from the organization's own knowledge. Defining each sub-agent in one checked file, registered with the rules that justify it
> and the checks it runs, states how AI agents work here in the repository itself, and keeps every agent's instructions tied to the rules
> they apply.

- [Clear and communicated AI stance](../../references/dora/capabilities.md#clear-and-communicated-ai-stance) — each agent's job, its limits,
  and the standard agent for delegated work are written down where every session starts.
- [AI-accessible internal data](../../references/dora/capabilities.md#ai-accessible-internal-data) — an agent works from the rules its
  registry entry cites, so its answers follow the repository's decisions rather than general habit.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a renumbered rule or a renamed check fails a check
  instead of leaving an agent that points at nothing.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Inspiration

`Inspiration — read for ideas, never a reference implementation`

[ADR-REPO-INSPIRE](inspiration.md)

> DORA's research ties delivery performance to a learning culture and to teams that try ideas and judge them on evidence. Reading a sibling
> repository for ideas shortens the search for a good shape, and weighing each idea against catzc's own ADRs, then rebuilding it to their
> rules, keeps that learning from turning into a second, unchecked set of rules.

- [Learning culture](../../references/dora/capabilities.md#learning-culture) — a solution a sibling found is read and learned from, not
  rediscovered.
- [Team experimentation](../../references/dora/capabilities.md#team-experimentation) — an idea is a candidate the ADRs judge, and the work
  says where it came from, so the reasoning stays reviewable.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — an idea is rebuilt to catzc's rules, never ported
  beside them, so the code keeps one living version of each behaviour.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Protected globs

`Protected globs — session-memory skip of repeated scans over an unchanged globset`

[ADR-REPO-PROTGLOB](protected-globs.md)

> Session-memory skipping of repeated scans over unchanged inputs cuts inner-loop feedback time without compromising CI proof. Fail-open
> architecture ensures every pipeline run proves the full set, maintaining fast-feedback and reliability together.

- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — CI never skips, always scans full, so protection
  never hides a violation from the merge gate.
- [Test automation](../../references/dora/capabilities.md#test-automation) — heavy read-only scans are skipped on an unchanged globset
  identity, providing rapid feedback on unchanged inputs.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — skipped scans cut iteration time in local
  inner loop.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
