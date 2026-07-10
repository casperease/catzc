# ADR: Versioned external API contracts and contract testing

## Rules: ADR-REPO-CONTRACT

### Rule ADR-REPO-CONTRACT:1

`contracts/` is the repository's external-facing API surface: the binding interface definitions an outside consumer is allowed to depend on.
Everything a consumer may rely on is expressed here as a contract; everything else in the repo is internal and governed by
[one living version](../principles/one-living-version.md) (change in place, no back-compat).

- [The contract surface is the only public API](#the-contract-surface-is-the-only-public-api)

### Rule ADR-REPO-CONTRACT:2

Contracts are versioned by folder — `contracts/<contract-name>/v<N>/`
([conventional-folders](conventional-folders.md#rule-adr-repo-folders11)). A backwards-incompatible change to a contract is a **new `v<N>`
folder** beside the existing ones; the prior versions stay in place, unchanged.

- [A new version is a new folder](#a-new-version-is-a-new-folder)

### Rule ADR-REPO-CONTRACT:3

Keeping old versions live is the one sanctioned backwards-compatibility in the repository. External consumers genuinely exist at this
boundary and cannot be changed in lockstep, so a published version is kept as long as a consumer pins it (this is
[ADR-PRIN-ONELIVE:7](../principles/one-living-version.md#rule-adr-prin-onelive7) made concrete), and retired only when no consumer's
contract requires it — a deliberate, contract-driven deprecation, not a hedge.

- [Why this is the one place back-compat is owed](#why-this-is-the-one-place-back-compat-is-owed)

### Rule ADR-REPO-CONTRACT:4

Contracts are **binding**, proven by contract testing: the provider (this repo) has tests that verify it honours every declared contract
version. A change that would break a published version fails CI here, not a consumer in production. This is what makes "kept for
back-compat" a guarantee rather than a hope.

- [Binding, by contract testing](#binding-by-contract-testing)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-CONTRACT:5

A published contract version is immutable. Evolving the interface means a new `v<N+1>`, never an edit to a published `v<N>` that a consumer
already depends on. `v0` is the only mutable, pre-publication draft (per
[ADR-REPO-FOLDERS:11](conventional-folders.md#rule-adr-repo-folders11)); once a version is declared (`v1`+), its folder is frozen.

- [A published version is frozen](#a-published-version-is-frozen)

## Context

The [one-living-version](../principles/one-living-version.md) principle holds for the **inside** of the repository: every internal caller is
in the tree and moves with a change, so there is no external consumer to keep a back-compat shim alive for. But the repository is not only
consumed from inside — it _publishes_ an API that outside consumers build against, and those consumers upgrade on their own schedule. That
boundary is the one place the "no external consumers" reasoning does not apply, and it needs a structure of its own rather than a
compatibility shim threaded through internal code.

`contracts/` is that structure. It makes the public surface explicit (so it is obvious what is a promise to the outside versus an internal
implementation detail), versioned (so an incompatible change is a new thing beside the old, not a mutation of it), and testable (so the
promise is verified mechanically, not asserted in a README).

### The contract surface is the only public API

Everything outside `contracts/` is internal. A consumer that reaches past the contract surface — into a module function, an internal config
schema, a data record — gets no compatibility promise and may break on any change, exactly as internal code does. The boundary is the
contract folder, and only the contract folder. This keeps the public commitment small and deliberate: you promise what you put in
`contracts/`, and nothing else.

### A new version is a new folder

A backwards-incompatible change does not edit the existing contract — it adds `v<N+1>/` beside it. The two versions then coexist as
separate, equally live folders, each its own self-contained definition. This is the versioned-coexistence that
[ADR-PRIN-ONELIVE:7](../principles/one-living-version.md#rule-adr-prin-onelive7) sanctions: not legacy kept grudgingly, but two supported
versions, each owned and tested. A backwards-_compatible_ change (additive, non-breaking) may land in the current version, since its
contract test still passes.

### Why this is the one place back-compat is owed

Backwards compatibility buys a grace period for consumers who cannot change in lockstep with the producer. Internally there are none — so
internally it is rejected. At the published boundary there genuinely are, so a published version stays live while a consumer pins it. The
cost (a maintained old version) buys something real here: it is the difference between an external consumer that keeps working and one that
breaks. Retirement is deliberate and evidence-based — a version goes away when its contract test shows no consumer needs it — not on a
guessed-at calendar.

### Binding, by contract testing

A contract is only a promise if breaking it is caught. The provider side of this repo carries contract tests that assert it still satisfies
every declared `contracts/<name>/v<N>`. The concrete form is chosen per contract — schema validation of a published shape, provider/consumer
(e.g. Pact-style) verification of a request/response surface, golden examples a consumer can replay — but the discipline is the same: a
change that violates a published version turns the suite red before it ships. Without the test, "we keep v1 working" is a hope; with it, it
is enforced.

### A published version is frozen

Once `v1` is declared, its folder is not edited — a consumer is already building against exactly those bytes. A fix or an evolution that
changes the contract is `v2`. The only mutable version is `v0`, the pre-publication draft (ADR-REPO-FOLDERS:11), which exists precisely so a
contract can be shaped before it becomes a binding promise. This immutability is what lets a consumer pin `v1` and trust it will not move
underneath them.

### Rejected alternatives

1. **One unversioned contract, evolved in place** — rejected: every change becomes a potential break for some consumer, and there is no way
   to support an old and a new shape at once. Versioned folders let the two coexist and be tested independently.

2. **Documenting the API in a README and trusting callers** — rejected: a prose promise is not verified, so it drifts from the code and
   breaks consumers silently. A binding, tested contract catches the break in CI.

3. **A back-compat shim in internal code** (dual-read the old and new shape inside the implementation) — rejected: it smears the public
   boundary through internal code, which then can never reach [one living version](../principles/one-living-version.md). The compatibility
   belongs at the boundary, as a separate versioned contract, not inside.

## Decision

The repository's public API is exactly the set of binding contracts under `contracts/<name>/v<N>/`. Incompatible changes add a new version
folder; published versions are immutable and kept live while an external consumer pins them; and each declared version is verified by
contract testing so a break is caught in CI, not in production. Everything outside `contracts/` is internal and follows one living version.

### How this is enforced

- **Contract tests** verify, provider-side, that the repo honours every declared `contracts/<name>/v<N>`. They run in CI alongside the rest
  of the suite; a change that breaks a published version fails there. The concrete mechanism (schema validation, provider/consumer
  verification, golden replay) is chosen per contract and lives with it.

- **Code review** guards what the tests cannot phrase: that an incompatible change adds a new `v<N>` rather than editing a published one
  (ADR-REPO-CONTRACT:5), that the public surface stays confined to `contracts/` (ADR-REPO-CONTRACT:1), and that a retirement is justified by
  the absence of a pinning consumer (ADR-REPO-CONTRACT:3).

## Consequences

- The public commitment is explicit and small: what is in `contracts/` is promised; everything else is free to change with one living
  version.
- An incompatible change never breaks a consumer silently — it is a new version folder, and the old one keeps passing its contract test
  until it is deliberately retired.
- The internal code stays shim-free: backwards compatibility is a boundary concern, expressed as versioned contracts, not as dual-read paths
  threaded through implementations.
- The cost is real and bounded: each live version is maintained and tested for as long as a consumer pins it. That cost buys the one thing
  it should — external consumers that keep working across change.
