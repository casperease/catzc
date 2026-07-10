# DORA explanations — github

The `Dora explains` rationale for the ADRs in the `github/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## GitHub release flow — publishing the Catzc package (`ADR-GH-RELEASE`)

DORA links deployment automation and continuous delivery to delivery performance: a release should be a repeatable, low-ceremony, auditable
act. A manually-dispatched workflow that always builds the artifact and publishes it GitHub-first on the built-in token makes releasing
catzc a single deliberate action, with the credential-heavy path (the Gallery) isolated behind an opt-in key.

- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — one dispatch builds and publishes the package to GitHub
  with no bespoke credentials.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — every run yields a versioned, downloadable artifact,
  publishable the moment it is wanted.
- [Version control](https://dora.dev/capabilities/version-control/) — a GitHub Release ties each published package to a tagged commit.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
