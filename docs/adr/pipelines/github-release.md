# ADR: GitHub release flow — publishing the Catzc package

## Rules: ADR-RELEASE

### Rule ADR-RELEASE:1

A release is **manual only**. `.github/workflows/release.yml` triggers on `workflow_dispatch` and nothing else — its trigger is deliberately
not wired to push, tag, or a globset projection (unlike CI, [protected-globs](../automation/protected-globs.md)). Publishing an artifact to
the outside world is a deliberate act, so a human starts it.

- [A release is a deliberate, manual act](#a-release-is-a-deliberate-manual-act)

### Rule ADR-RELEASE:2

Every run **builds the artifact and uploads it; publishing is separate and opt-in**. The build step runs `Export-Catzc -To nuget` to produce
the `.nupkg` and the PSGallery module manifest and uploads them as a workflow artifact unconditionally; each publish step is gated on its
own input and no-ops without its token. A run with no publish inputs simply produces the package — the "just build it" path.

- [Build always, publish on purpose](#build-always-publish-on-purpose)

### Rule ADR-RELEASE:3

**GitHub is the primary target, published with the built-in `GITHUB_TOKEN`** — no PowerShell Gallery key required. A GitHub Release (with
the `.nupkg` attached) is created with the `gh` CLI, and GitHub Packages is pushed with `dotnet nuget push`; both authenticate with the
Actions-provided `github.token`. Consumers install from the GitHub NuGet feed as a registered PSResource repository.

- [GitHub first, on the GitHub token](#github-first-on-the-github-token)

### Rule ADR-RELEASE:4

**PowerShell Gallery is opt-in and needs its own key.** The PSGallery publish runs only when its input is set, reads `PSGALLERY_API_KEY`
from secrets, and — when that secret is empty — **skips with a warning rather than failing**, leaving the built `.nupkg` and manifest in
place. The GitHub token can never publish to PSGallery; that is the one place a PSGallery API key is used.

- [PowerShell Gallery is opt-in](#powershell-gallery-is-opt-in)

### Rule ADR-RELEASE:5

The **published version is `exporter.yml`'s `version`** (a real semver), distinct from the `6.6.666` direct-install sentinel
([platform-bundle](../automation/platform-bundle.md)). Package identity — the stable module GUID and the author/description/tags of the
manifest — is that same one export config, so what the package claims about itself is reviewed data, not workflow literals.

- [One version, one identity, from config](#one-version-one-identity-from-config)

## Context

The platform builds itself into an installable NuGet package (`Export-Catzc -To nuget` — the `.nupkg` plus a PSGallery-compatible
`Catzc.psd1`). What remained was how that package reaches consumers from a GitHub-hosted repository. The PowerShell Gallery is the obvious
public registry, but publishing to it means holding a Gallery API key as a secret and treating every workflow run as a potential live
publish — more ceremony and more risk than a repository wants for a package that, at this stage, mostly needs to exist as a downloadable,
versioned artifact. GitHub already issues a scoped `GITHUB_TOKEN` to every Actions run, and both a GitHub Release and the GitHub Packages
NuGet feed accept it, so the primary distribution can ride the token the platform already has.

## Decision

Ship a manually-triggered release workflow that always builds the package and publishes it, GitHub-first, on the GitHub token — with the
PowerShell Gallery as an opt-in target behind its own key.

### A release is a deliberate, manual act

The workflow triggers only on `workflow_dispatch`. There is no push/tag/globset trigger, so nothing publishes by accident: a maintainer
starts a release and chooses, per run, what to publish. This is the opposite of CI, which fires automatically on a change to its globset — a
release is not a consequence of a commit, it is a decision about one.

### Build always, publish on purpose

The first step builds the artifact and uploads it; it never depends on any token. Each publish step is guarded by its own boolean input and,
where a token is involved, by that token's presence. So a run is a spectrum: with no inputs it is a pure build (the artifact is produced and
attached, nothing leaves), and each input turns on exactly one destination. "Just build the package and the manifest" is therefore the
default behaviour, not a special mode.

### GitHub first, on the GitHub token

GitHub distribution uses the `gh` CLI and `dotnet nuget push`, both authenticated by the Actions `github.token` — no PowerShell Gallery key
is involved. A GitHub Release tags the version and attaches the `.nupkg` for direct download; GitHub Packages exposes it as a NuGet v3 feed
that a consumer registers as a PSResource repository (`Register-PSResourceRepository`) and installs from (`Install-PSResource Catzc`). This
is the token-light path the repository already has the credentials for.

### PowerShell Gallery is opt-in

Publishing to the Gallery is a separate, opt-in step. It runs only when its input is set, and it reads `PSGALLERY_API_KEY` from secrets; if
that secret is absent or empty, it prints a warning and exits success, so a maintainer who forgot the key gets a built artifact, not a
failed run. The GitHub token has no power on the Gallery — the Gallery is the one target that needs its own credential — so the two paths
stay cleanly separate.

### One version, one identity, from config

The package publishes under `exporter.yml`'s `version` (a real semver), not the `6.6.666` sentinel that names direct on-disk installs. The
module's stable GUID and its Gallery metadata (author, company, description, tags, optional project/license URIs) come from that same single
export config, validated on load — so the identity the package asserts is reviewed data in one file, never scattered literals in the
workflow.

## Consequences

- A maintainer releases with one manual dispatch and gets, at minimum, a built and uploaded package — and, by ticking inputs, a GitHub
  Release, a GitHub Packages push, and/or a PowerShell Gallery publish.
- The common path needs no secret at all: GitHub distribution rides the built-in token, so a Gallery key is required only to reach the
  Gallery.
- Nothing publishes by accident: no automatic trigger, and each destination is an explicit choice per run.
- A forgotten or absent Gallery key degrades to build-only with a warning, never a red run.
- The cost is a second workflow and the discipline of keeping package identity in `exporter.yml` rather than the workflow — bounded, and the
  same config the build already reads.

## Related

- [platform-bundle](../automation/platform-bundle.md) — the artifact this releases and the sentinel-vs-published version split.
- [protected-globs](../automation/protected-globs.md) — the globset-projected CI trigger this workflow deliberately does not use.
- [ci-discipline-and-promotion-flow](../design/ci-discipline-and-promotion-flow.md) — the build-once/deploy-many flow this completes at the
  publish end.
- [vendor-toolset-dependencies](../automation/powershell/vendor-toolset-dependencies.md) — PSResourceGet, which packs and publishes the
  module.

## Dora explains

DORA links deployment automation and continuous delivery to delivery performance: a release should be a repeatable, low-ceremony, auditable
act. A manually-dispatched workflow that always builds the artifact and publishes it GitHub-first on the built-in token makes releasing
catzc a single deliberate action, with the credential-heavy path (the Gallery) isolated behind an opt-in key.

- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — one dispatch builds and publishes the package to GitHub
  with no bespoke credentials.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — every run yields a versioned, downloadable artifact,
  publishable the moment it is wanted.
- [Version control](https://dora.dev/capabilities/version-control/) — a GitHub Release ties each published package to a tagged commit.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
