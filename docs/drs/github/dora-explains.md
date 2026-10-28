# DORA explanations — github

The `Dora explains` rationale for the records in the `github/` domain, consolidated in one place. Each entry names its record and rule code,
then reproduces that record's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The decisions
live in the records themselves; this file carries only their DORA rationale.

## GitHub release flow

`GitHub release flow — publishing the Catzc package`

[ADR-GH-RELEASE](github-release.md)

> DORA links deployment automation and continuous delivery to delivery performance: a release should be a repeatable, low-ceremony,
> auditable act. A manually-dispatched workflow that always builds the artifact and publishes it GitHub-first on the built-in token makes
> releasing catzc a single deliberate action, with the credential-heavy path (the Gallery) isolated behind an opt-in key.

- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — one dispatch builds and publishes the package to
  GitHub with no bespoke credentials.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — every run yields a versioned, downloadable artifact,
  publishable the moment it is wanted.
- [Version control](../../references/dora/capabilities.md#version-control) — a GitHub Release ties each published package to a tagged
  commit.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## GitHub Actions

`GitHub Actions — the run mark and the path-filter triggers of a workflow`

[ADR-GH-ACTIONS](github-actions.md)

> DORA links continuous integration and version-controlled configuration to faster, more reliable delivery. A workflow whose `paths` filter
> is generated from the one committed globset, and checked for drift, runs exactly when its unit changes, and one named run mark keeps the
> automation's pipeline behaviour the same on GitHub as elsewhere.

- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — an exact, generated trigger runs CI on every
  change to the unit and on nothing else.
- [Version control](../../references/dora/capabilities.md#version-control) — the trigger is derived from the committed globset, never
  hand-kept beside it.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — a quality gate keeps the generated trigger honest
  without a manual step.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
