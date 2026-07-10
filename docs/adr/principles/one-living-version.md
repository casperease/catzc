# Principle: One living version — no legacy, no back-compat, history in git

## Rules: ADR-PRIN-ONELIVE

### Rule ADR-PRIN-ONELIVE:1

The codebase expresses exactly one version of every **internal** behaviour — the current one. No legacy variant of our own code coexists
(`Verb-NounV2`, `*_old`, `legacy/`, a parallel "new" path beside the old); replacing behaviour means changing it **in place**, not adding a
second copy. This governs the codebase's own behaviour — not version as a deliberate contract value, which is legitimate
(ADR-PRIN-ONELIVE:7).

- [One version, by construction](#one-version-by-construction)
- [Version as a first-class contract is not legacy](#version-as-a-first-class-contract-is-not-legacy)

### Rule ADR-PRIN-ONELIVE:2

No backwards-compatibility shims. No deprecated aliases, compatibility fields, dual-read fallbacks, or migration bridges live in current
code. When a contract changes — a config schema, a data model, a function signature — every caller is updated in the **same** change, and
the old shape leaves no residue. The one bounded exception is a temporary branch-by-abstraction seam during a wholesale swap
(ADR-PRIN-ONELIVE:8), which exists only to be removed.

- [Why an internal mono-repo owes no back-compat](#why-an-internal-mono-repo-owes-no-back-compat)
- [Branch by abstraction: temporary coexistence for a wholesale swap](#branch-by-abstraction-temporary-coexistence-for-a-wholesale-swap)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PRIN-ONELIVE:3

No legacy or dead code kept "just in case." Code that is no longer reached is **deleted** — not commented out, not parked behind a disabled
flag, not moved to an `old/` folder. If it is ever needed again, it is recovered from git.

- [History lives in git, not in the tree](#history-lives-in-git-not-in-the-tree)

### Rule ADR-PRIN-ONELIVE:4

Trunk-based development. Work integrates continuously into a single mainline; there are no long-lived release or version branches carrying
an alternate version of the code. Branches are short-lived and merge back. The trunk **is** the one version.

- [Trunk is the one version](#trunk-is-the-one-version)

### Rule ADR-PRIN-ONELIVE:5

History lives in git, not in the working tree. The record of what the code used to be is `git log` / `git blame` — never a retained old
file, a `# previously …` comment, an in-code changelog, or a commented-out alternative. The working tree shows only the present.

- [History lives in git, not in the tree](#history-lives-in-git-not-in-the-tree)

### Rule ADR-PRIN-ONELIVE:6

Docs read present-tense, like the code. An ADR, README, or help block describes the current design as if it had always been so — no
"deprecated", "legacy", "as of vX", "we used to", "this replaces". That history is in git. This is the [authoring convention](../README.md)
("Present tense, not a changelog") applied to the whole tree, not only to ADRs.

- [History lives in git, not in the tree](#history-lives-in-git-not-in-the-tree)

### Rule ADR-PRIN-ONELIVE:7

Version as a first-class contract is not legacy. Pinning an external tool, vendored module, or API version — or an explicit `schema_version`
you own and validate — is a deliberate contract value, and versioned coexistence is legitimate there. The line from forbidden back-compat
(ADR-PRIN-ONELIVE:2): every supported version is **equally live and intended**, owned and tested — not a deprecated shadow kept only to
defer changing callers. Versioned contracts have a structural home: `contracts/<contract-name>/v<N>/`
([conventional-folders](../repository/conventional-folders.md#rule-adr-repo-folders11)).

- [Version as a first-class contract is not legacy](#version-as-a-first-class-contract-is-not-legacy)

### Rule ADR-PRIN-ONELIVE:8

A wholesale replacement may use **branch by abstraction**: a temporary seam behind which the old and new implementations coexist for a few
integrations to master — optionally config-selected — so the swap lands incrementally on trunk instead of on a long-lived branch. It is
bounded and removed on cutover (the seam, the old implementation, and any toggle deleted together), landing back on one living version. It
is a migration scaffold with a built-in deletion plan and a deadline, not the indefinite back-compat ADR-PRIN-ONELIVE:2 forbids.

- [Branch by abstraction: temporary coexistence for a wholesale swap](#branch-by-abstraction-temporary-coexistence-for-a-wholesale-swap)

## Context

This repository is an internal mono-repo: an automation platform and its infrastructure-as-code, whose every **internal** consumer lives in
the same tree. Nothing outside it pins a version of an internal function, config schema, or data model — so internally there is no external
consumer that cannot be changed in lockstep, the only real reason a codebase carries backwards compatibility.

The one place external consumers _do_ exist is the repository's deliberately published API surface, and that is exactly why it is versioned
explicitly — as binding contracts under `contracts/<name>/v<N>/`, kept honest by contract testing (see
[api-contracts](../repository/api-contracts.md)). Back-compat for those consumers is legitimate and lives **there**, as separate live
versions — never as a shim smeared through the internal code. Everything below is about the inside; the external API boundary is the
deliberate, versioned exception (ADR-PRIN-ONELIVE:7).

Without that reason, legacy is pure cost. Two versions of a behaviour double the surface to read, test, and reason about; they drift; and
every reader must first work out which one is live. A deprecated alias kept "for safety" is a second source of truth that quietly diverges.
Commented-out code rots, because nothing compiles or tests it. The instinct to keep the old thing around is an artifact of environments
where rollback is expensive and consumers are external — neither of which applies here.

The discipline that makes this safe is already in place: trunk-based development with all callers in-tree means a contract change and every
one of its call sites move in a **single** change, atomically. There is never a window where half the tree speaks the old contract and half
the new — so there is nothing for a compatibility shim to bridge.

### One version, by construction

There is one definition of each behaviour, and changing behaviour edits that definition. The alternative — adding `Do-ThingV2` beside
`Do-Thing`, or a `new/` path beside the old — multiplies variability (see [reduce-variability](reduce-variability.md)) and breaks the
single-source-of-truth that [everything-as-code](everything-as-code.md) depends on. One version is also what makes the platform legible: a
reader who finds a function knows it is **the** function, not one of several vintages.

### Why an internal mono-repo owes no back-compat

Backwards compatibility buys a grace period for consumers who cannot change in lockstep with a producer. Here there are no such consumers —
every caller is in the tree and moves with the change. So the producer pays the full cost of a compatibility layer (the shim, its tests, the
cognitive load of "which path runs when") to buy nothing. The honest move is the atomic one: change the contract and every caller together,
and delete the old shape in the same commit. This is permanent and repo-wide, not a temporary stance: the mono-repo's all-callers-in-tree
property is what makes backwards compatibility pointless, and that property holds for every change.

### History lives in git, not in the tree

Every past version of every line is already preserved, perfectly and for free, in git. Keeping a second copy in the working tree — a
commented-out block, an `_old` file, a "# was: …" note — duplicates what git already holds, except worse: it is unversioned, untested, and
misleads the next reader into thinking it is live. `git log` and `git blame` are the archive. The tree is the present tense.

### Trunk is the one version

Trunk-based development is the workflow that makes "one version" hold over time. A long-lived release or version branch is just legacy with
a branch name: it carries an alternate version of the code that drifts from trunk and eventually demands a back-merge or a compatibility
shim. Short-lived branches that merge back keep the trunk as the single, living version at all times.

### Version as a first-class contract is not legacy

This principle governs the codebase's own behaviour; it does not forbid _version_ as a deliberate value of the domain. Some contracts are
inherently versioned, and pinning or supporting a specific version is the spec, not residue:

- **External dependency versions** — the tool versions pinned in `Catzc.Tooling.Core`'s `tools.yml` (asserted by `Assert-ToolVersion`), and
  the version-pinned vendored modules under `automation/.vendor/<name>/<version>/`. These name exactly which external version we target;
  carrying more than one is a deliberate choice the external world forces, not legacy.
- **External API versions** — when an external service (the `az` CLI, the ADO REST API) exposes versioned endpoints, targeting a given
  `api-version` is part of the contract.
- **An explicit `schema_version` you own and validate** — a declared, checked part of a data contract, not a hidden compatibility fallback.

The tell that separates a versioned contract from legacy: in a versioned contract, **every supported version is equally live and intended**
— each fully owned and tested. In legacy, one version is the real one and the other is kept alive grudgingly to defer changing callers,
which is what ADR-PRIN-ONELIVE:2 forbids. Versioned coexistence is fair for the former and forbidden for the latter.

Versioned contracts also have a **structural home**, which keeps them from being mistaken for legacy: the root
`contracts/<contract-name>/v<N>/` convention ([conventional-folders](../repository/conventional-folders.md#rule-adr-repo-folders11)) — one
named contract folder is the boundary (like an `infrastructure/templates/<name>/`), with `v1`, `v2`, … inside. Each version is its own
self-contained, checked-in folder (kept by a `.gitkeep`), so coexistence is explicit and located — never an ad-hoc `V2` fork buried beside
the original in the code. These are the repository's external-facing API contracts, binding and contract-tested — see
[api-contracts](../repository/api-contracts.md).

### Branch by abstraction: temporary coexistence for a wholesale swap

Replacing a module or component wholesale is exactly the case trunk-based development handles with **branch by abstraction**, and it is
sanctioned here. Introduce an abstraction seam in front of the thing being replaced; build the new implementation behind the same seam; let
the two coexist briefly — optionally selected by config — while a small set of CI integrations cut callers over. Then delete the old
implementation, the toggle, and usually the seam itself, in the same flow.

What keeps this inside the principle is that it is **temporal**. The seam is a construct to lift the old thing out and the new thing in,
over a few integrations to master, not a permanent layer. It has a built-in end state — one living version — and the migration is not
finished until the scaffold is gone. That is the opposite of legacy: legacy is coexistence with no removal plan and no deadline; branch by
abstraction is coexistence whose entire purpose is to reach one version faster and more safely than a big-bang rewrite or a long-lived
branch would. Use it to _get to_ one version; the failure mode is letting the seam calcify into a permanent two.

### Deprecation cycles

1. **Deprecation cycles in internal code** (mark an internal shape old, keep it for N releases) — rejected: a deprecation window serves
   external consumers who migrate on their own schedule, and internal code has none — all callers are in-tree and move with the change. At
   the published API boundary it is different: retiring a `contracts/<name>/v<N>` version is a deliberate, contract-tested deprecation,
   because external consumers genuinely pin it (ADR-PRIN-ONELIVE:7). What is rejected is deprecation as a hedge in internal code, not the
   versioned external contracts. (A bounded branch-by-abstraction swap is also not this: it has a deadline and a deletion plan, and serves
   the migration itself.)

### Rejected alternatives

1. **Commenting out / parking old code** ("might need it") — rejected: git already preserves it, versioned and recoverable. Code in the tree
   that nothing runs is a liability, not a backup.

## Decision

The repository carries exactly one living version of every behaviour. Contract changes are atomic across all in-tree callers, with no
compatibility shim, deprecated alias, or migration fallback. Dead code is deleted, not parked. Development is trunk-based. The history of
what the code used to be lives in git and nowhere else — not in retained files, not in comments, not in present-tense docs.

### How this is enforced

- **Code review** is the primary gate: a reviewer rejects an unplanned `V2`-beside current-`V1`, a deprecated alias, a commented-out block,
  a "legacy" note, or a long-lived version branch, against this ADR. A bounded branch-by-abstraction seam with a stated deletion plan
  (ADR-PRIN-ONELIVE:8) is the exception — the reviewer checks that the scaffold is temporary and tracked, not that it merely exists.

- **Strict config validation** keeps the principle structural where it can: the `Assert-*Config` schema checkers reject unknown / deprecated
  keys, so a compatibility field cannot quietly linger in a config — removing the key from the schema forces it out of every file in the
  same change.

- **The present-tense ADR/doc convention** (`docs/adr/README.md`, "Present tense, not a changelog") enforces ADR-PRIN-ONELIVE:6 in review
  for all documentation.

## Consequences

- The tree shows one version of everything. A reader never has to ask which of several copies is live.
- Changes are atomic and complete: a contract and all its callers move together, so there is never a mixed-contract window and never a shim
  to bridge one.
- The codebase stays small — no parallel paths, no dead branches of logic, no parked files accumulating.
- Recovering an old version is a `git` operation, not a tree excavation. The archive is complete and the present is uncluttered.
- The cost is discipline and nerve: you must change every caller now and trust git to hold the past, rather than hedging with a copy. In an
  all-in-tree mono-repo that trust is well-founded.
