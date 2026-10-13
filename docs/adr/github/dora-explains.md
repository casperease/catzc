# docs/adr/github/dora-explains.md

DORA explanations — github

The `Dora explains` rationale for the ADRs in the `github/` domain, consolidated in one place. Each entry names its ADR and rule code, then
reproduces that ADR's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The decisions live in
the ADRs themselves; this file carries only their DORA rationale.

## GitHub release flow — publishing the Catzc package (`ADR-GH-RELEASE`)

DORA links deployment automation and continuous delivery to delivery performance: a release should be a repeatable, low-ceremony, auditable
act. A manually-dispatched workflow that always builds the artifact and publishes it GitHub-first on the built-in token makes releasing
catzc a single deliberate action, with the credential-heavy path (the Gallery) isolated behind an opt-in key.

- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — one dispatch builds and publishes the package to
  GitHub with no bespoke credentials.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — every run yields a versioned, downloadable artifact,
  publishable the moment it is wanted.
- [Version control](../../references/dora/capabilities.md#version-control) — a GitHub Release ties each published package to a tagged
  commit.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
