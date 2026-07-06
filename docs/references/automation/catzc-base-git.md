# Catzc.Base.Git

The declarative git-configuration module. It owns the rule that **what git ignores is declared, explained, and generated**: the
repository-root `.gitignore` is rendered in full from a zone registry (`gitignore.yml`) — every rule under a titled, explained comment block
— and never hand-maintained (see [generated-root-configs](../../adr/repository/generated-root-configs.md)). What it deliberately does
**not** own is the materialisation: `New-GitIgnore` is a pure renderer that returns content and writes nothing; the `.gitignore` target
itself is a managed, committed root file written by [Catzc.Base.RootConfig](catzc-base-rootconfig.md)'s `Build-RootConfig`, which names
`New-GitIgnore` as that entry's generator.

## Domains

| Domain   | Area     | Name                                                 |
| -------- | -------- | ---------------------------------------------------- |
| domain:1 | render   | [Gitignore rendering](#domain1--gitignore-rendering) |
| domain:2 | registry | [The zone registry](#domain2--the-zone-registry)     |

### domain:1 — Gitignore rendering

Turning the zone registry into the full `.gitignore` text. This domain renders a generated-file header naming the sources of truth, then
each zone in registry order: a rule line carrying the zone's title, the wrapped `why` explanation as comment lines, and the zone's patterns
verbatim — a `note` becomes an aligned trailing comment. A zone declaring `inject: <provider>` takes its patterns from the caller at render
time; a provider the caller does not supply throws, so a silently incomplete `.gitignore` can never render. Pattern text is never rewritten
— what the registry says is what git gets.

### domain:2 — The zone registry

Which paths are ignored, grouped and explained. The registry is `gitignore.yml`: an ordered list of **zones**, each with an `id`, a `title`,
a `why`, and either static `patterns` (bare strings or `{ pattern, note }`) or an `inject` provider name. The managed root-config copies are
the injected zone — their list lives in [Catzc.Base.RootConfig](catzc-base-rootconfig.md)'s registry (the `committed: false` targets) and is
never restated here, which is also what keeps the dependency edge one-way: `Build-RootConfig` computes the injection and calls the renderer;
`New-GitIgnore` never reads `rootconfig.yml`. The registry is validated when it loads (`GitIgnoreConfig` — exactly one of
`patterns`/`inject` per zone, unique ids), so a malformed zone can never produce a run.

## What the module does

The module is small and single-purpose: it makes the repository's ignore rules a reviewed, explained artifact instead of an accreted one.
Every rule in the generated `.gitignore` sits under a heading and a rationale, so "why is this ignored?" is answered in the file itself, and
adding a rule means adding it to a zone (or a new zone) in `gitignore.yml` — the render carries the explanation along.

The split with [Catzc.Base.RootConfig](catzc-base-rootconfig.md) is the deliberate design: this module knows **what** is ignored and **how
to say it**; RootConfig knows **which root files are managed** and **owns every write**. The `.gitignore` file is `committed: true` in the
root-config registry — git must read it at checkout, before any import — so a fresh clone ignores correctly from the first second, the
importer merely keeps it current, and a source change surfaces as a normal reviewable diff. The injected zone closes the loop: opting a new
root file into management (`committed: false`) puts its ignore line into the next rendered `.gitignore` automatically, with no second list
to maintain.

## Division

The module's public surface, sorted into the domains above.

| Domain                         | Function        |
| ------------------------------ | --------------- |
| domain:1 — Gitignore rendering | `New-GitIgnore` |
| domain:2 — The zone registry   | `gitignore.yml` |
