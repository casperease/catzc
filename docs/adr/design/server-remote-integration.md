# ADR: The audited server git remote — verified integration and PR ingress

The mainline lives on an **audited server git remote** (Azure DevOps or GitHub); every developer box and CI agent is a client that bridges
to it. This ADR fixes how work crosses that boundary in both directions: what a consumer reads _out_ (integrate from the last verified
commit, never the dirty remote HEAD) and how a change gets _in_ (ingress through a pull request that authenticates and merges). The
commit-lifecycle states it builds on — the stable sync point and the dirty HEAD — are owned by [commit-lifecycle](commit-lifecycle.md)
(`ADR-LIFE`); this ADR owns the remote topology and the integration/ingress discipline over it.

## Rules: ADR-REMOTE

### Rule ADR-REMOTE:1

**The audited server git remote is the single source of truth; local and CI repositories are bridges to it.** The mainline (`main` /
`master`) that governs is the one on the server remote — Azure DevOps or GitHub — where identity, branch-protection policy, and the
immutable audit history are enforced. A developer box and a CI agent each hold a **local clone** that bridges to that remote; a local
branch's view of "main" is provisional until it is what the server holds. The server is the authority; the client is a working copy.

- [The server remote is the authority](#the-server-remote-is-the-authority)

### Rule ADR-REMOTE:2

**Integrate from the last remote-verified commit, never from the current remote HEAD.** The tip of the server's main (its HEAD) may be a
**dirty HEAD** — landed but still unverified, or verified-then-failed downstream (ADR-LIFE:7). Any consumer that builds on the mainline — a
developer starting work, a downstream deployable-unit, an upstream integrator — syncs against the **last commit the server proved verified**
(the stable point of ADR-LIFE:6), not the raw tip. "Latest" and "safe to build on" are different questions; this rule answers the second.

- [Integrate from verified, not HEAD](#integrate-from-verified-not-head)

### Rule ADR-REMOTE:3

**Integrating from verified avoids ever having to reconcile a rewritten or superseded tip.** A dirty HEAD is provisional: it may be fixed
forward by a successor, superseded by a newer commit that overtakes it, or — where the failed tail is reconciled — cut back. A consumer that
built on the verified point never has to negotiate any of that, because the verified history is stable and monotonic (ADR-LIFE:1) and does
not move under it. A consumer that built on the dirty tip inherits its instability and must reconcile when the tip is later fixed. Integrate
from verified and the reconciliation problem does not exist.

- [Why verified is stable and the tip is not](#why-verified-is-stable-and-the-tip-is-not)

### Rule ADR-REMOTE:4

**A pull request is the authenticated ingress engine, not merely a review.** In the audited regime (`git_workspace: main-via-pr`,
[ADR-VARIANT:6](../repository/repo-variants.md#rule-adr-variant6)) the PR is the one sanctioned way a change enters the server's `main` /
`master`: it **authenticates** the author against the server's identity model, runs the mandatory gates as a merge precondition, and
**performs the merge** itself. Review is one gate a PR can carry, but the load-bearing role is authentication-plus-merge: the PR is the
audited doorway, and closing every other door — no direct push to the protected branch — is what lets the `git log` audit trail be trusted
as complete. Solo `main-direct` is the deliberate single-author exception (ADR-VARIANT:6).

- [PR is authenticated ingress, not just review](#pr-is-authenticated-ingress-not-just-review)

## Context

Trunk-based development ([one-living-version](../principles/one-living-version.md), `ADR-ONELIVE:4`) puts one mainline at the centre, and
[self-service](self-service.md) (`ADR-SELFSERV`) rests its whole audit-and-approval story on that mainline living somewhere every change is
attributed, gated, and recorded. That somewhere is the **server** git remote — the ADO or GitHub repository whose branch policy and identity
model make those guarantees real. Developer and CI machines are clients that clone and bridge to it.

Two questions arise at that client/server boundary, and this ADR answers both. Reading _from_ the remote: the tip of main is not always safe
to build on, because it can be a dirty HEAD (the worked example in [commit-lifecycle](commit-lifecycle.md) makes this concrete — a tip that
was verified and then failed L3). Writing _to_ the remote: how does a change legitimately become part of the audited main at all? The answer
to the first is "integrate from the last verified commit"; the answer to the second is "through a PR, which is the authenticated ingress" —
and the two together are what keep the mainline both trustworthy to build on and honest about its history.

## Decision

Treat the server git remote as the audited source of truth, bridged by local clones. Consumers **integrate from the last verified commit,
not the remote HEAD**. Changes enter only through a **PR that authenticates and merges** them. Together these make a dirty HEAD a non-event
for everyone downstream and keep the audit trail complete.

### The server remote is the authority

The mainline is not a local artifact — it is the branch the server remote enforces, and the server is where identity, branch protection, and
the immutable audit log live. A local clone is a bridge: it fetches from and pushes toward that remote, but "what is on main" is decided by
the server, not by any client's local `main`. The guarantees the platform depends on — every change on main attributed, reviewed, and gated
(`ADR-SELFSERV`) — are server-side facts. A local `main` that has diverged, or a local commit never pushed through the sanctioned path, is
not "on main" in the sense that governs; it is working state that has not yet crossed the boundary.

### Integrate from verified, not HEAD

The server's main advances by landing commits, but landing is not the same as being verified. At any moment the tip may be a commit whose
gates have not run, or one that ran them and failed — a dirty HEAD (ADR-LIFE:7). Reading the tip therefore gives "the newest commit," which
is precisely not "the newest commit safe to build on." The last commit the server proved verified — the stable point ADR-LIFE:6 names as the
always-on environment's occupant — is the one to integrate from. A developer branches from it; a downstream unit builds against it; an
upstream consumer syncs to it. The rule is uniform across every consumer of the mainline: integrate from the last verified commit, never the
raw HEAD.

### Why verified is stable and the tip is not

The verified history is monotonic and immutable: a commit that reached the verified point is a durable fact no later event un-makes
(ADR-LIFE:1, `ADR-ONELIVE`). The dirty tip is the opposite — provisional. It might be fixed forward by a successor, superseded by a newer
commit that overtakes it, or, when the failed tail is reconciled, cut back. Whatever happens, the tip is subject to change while the
verified point is not. So the choice of integration base is a choice between a stable anchor and a moving one. Building on the stable anchor
means a later fix to the tip is simply the next thing you pull; building on the moving tip means that same fix can rewrite the ground under
your work and force a reconciliation you did not need to have. Integrating from verified is what makes "the dirty HEAD got fixed later" a
non-event for everyone downstream.

### PR is authenticated ingress, not just review

It is easy to read a pull request as a review checkpoint — a second pair of eyes. That undersells it. In the audited regime the PR is the
**only** ingress into the server's mainline, and it is what makes ingress _safe_: it authenticates the change against the server's identity
model (so every commit on main is attributable to an authenticated principal), runs the mandatory gates as a merge precondition, and
performs the merge itself — the change reaches `main` / `master` by no other route. Review is one of the gates a PR can carry; the
load-bearing property is authentication-plus-merge. The PR is the audited doorway, and closing every other door (no direct push to the
protected branch) is what lets the audit trail in `git log` be trusted as complete. The solo `main-direct` mode (`ADR-VARIANT:6`) is the
deliberate exception for a single-author trunk, where the author _is_ the sole authenticated principal and the doorway collapses to a direct
commit; the moment there is more than one author, the PR ingress is what keeps the mainline audited.

## How this is enforced

- **Server branch policy** — the protected `main` / `master` on the ADO / GitHub remote admits merges only through a PR, so ingress cannot
  bypass the authenticate-and-merge path (`ADR-REMOTE:4`).
- **`git_workspace` variant** — `main-via-pr` vs `main-direct` (`ADR-VARIANT:6`) selects the audited-ingress regime; `Sync-GeneratedFile`'s
  branch guard is the local half.
- **The stable sync point** — `ADR-LIFE:6` (integrate from the always-on environment's occupant) and `ADR-LIFE:7` (the dirty HEAD) supply
  the "last verified commit" this ADR tells consumers to integrate from.
- **Code review** — a build or workflow that pins its integration base to the remote HEAD rather than the last verified commit, or a process
  that reaches the protected branch outside a PR, is rejected against this ADR.

## Consequences

- A dirty HEAD is a non-event downstream: consumers built on the verified point never reconcile a tip that is later fixed, superseded, or
  cut back.
- "What is on main" has one authority — the server remote — so local divergence and un-pushed commits are visibly _not yet_ integrated, not
  a competing truth.
- The audit trail in `git log` is trustworthy as complete, because the PR is the only authenticated doorway into the protected mainline.
- The cost is discipline: consumers must resolve the last-verified commit rather than grab the tip, and every ingress pays the PR's
  authenticate-and-gate step — which is exactly the step that earns the audit and stability guarantees.

## Related

- [commit-lifecycle](commit-lifecycle.md) (`ADR-LIFE`) — the stable sync point (`:6`) and the dirty HEAD (`:7`) this ADR integrates from.
- [one-living-version](../principles/one-living-version.md) (`ADR-ONELIVE`) — trunk-based development and immutable history.
- [self-service](self-service.md) (`ADR-SELFSERV`) — the audit / change-approval guarantees the server remote and PR ingress make real.
- [repo-variants](../repository/repo-variants.md) (`ADR-VARIANT:6`) — the `git_workspace` PR-vs-Direct integration mode.
- [ci-discipline-and-promotion-flow](ci-discipline-and-promotion-flow.md) (`ADR-FLOW`) — the verification the "verified commit" has cleared.

## Dora explains

DORA identifies trunk-based development, version control, and lightweight change approval as predictors of delivery performance. Integrating
from the last verified commit keeps the trunk continuously integrable without exposing consumers to a dirty tip, and making the PR the
authenticated ingress keeps change approval built-in and the audit trail complete.

- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — integrate from the stable verified point so the trunk
  stays continuously integrable and a dirty tip never propagates.
- [Version control](https://dora.dev/capabilities/version-control/) — the audited server remote is the single source of truth with a
  complete, attributable history.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — the PR is built-in, authenticated ingress
  and approval, not a heavyweight external gate.
- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — authenticating every ingress at the PR keeps every commit on
  main attributable to a known principal.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
