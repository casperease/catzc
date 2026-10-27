# Design: The audited server git remote — verified integration and PR ingress

The mainline lives on an **audited server git remote** (the git host); every developer box and CI agent is a client that bridges to it. This
DDR fixes how work crosses that boundary in both directions: what a consumer reads _out_ (integrate from the last verified commit, never the
dirty remote HEAD) and how a change gets _in_ (ingress through a pull request that authenticates and merges). The commit-lifecycle states it
builds on — the stable sync point and the dirty HEAD — belong to the delivery flow's commit lifecycle; this DDR owns the remote topology and
the integration/ingress discipline over it.

## Rules: DDR-REMOTE

### Rule DDR-REMOTE-SERVERREMOTEISTRUTH

**The server's main is the authoritative copy of the repository; local and CI repositories are bridges to it.** The repository is the one
source of truth ([everything-as-code](../principles/everything-as-code.md)), and the copy of it that governs is the mainline (`main` /
`master`) on the audited server remote, where identity, branch-protection policy, and the immutable audit history are enforced. A developer
box and a CI agent each hold a **local clone** that bridges to that remote; a local branch's view of "main" is provisional until it is what
the server holds. The server's other state, its refs and pull requests, stays a fact source, read and never written as truth. The server
holds the authoritative copy; the client holds a working copy.

- [The authoritative remote](#the-authoritative-remote)

### Rule DDR-REMOTE-INTEGRATEFROMVERIFIED

**Integrate from the last remote-verified commit, never from the current remote HEAD.** The tip of the server's main (its HEAD) may be a
**dirty HEAD** — landed but still unverified, or verified-then-failed downstream, and so unsafe to build on. Any consumer that builds on the
mainline — a developer starting work, a downstream deployable-unit, an upstream integrator — syncs against the **last commit the server
proved verified** (the BVT-verified server head, the stable sync point), not the raw tip. "Latest" and "safe to build on" are different
questions; this rule answers the second. A dirty HEAD is provisional: it may be fixed forward by a successor or superseded by a newer commit
that overtakes it; history is never rewritten. A consumer that built on the verified point never has to reconcile a fixed or superseded tip,
because the verified history is stable and monotonic (a commit's state only ever advances) and does not move under it; a consumer that built
on the dirty tip inherits its instability and must reconcile when the tip is later fixed.

- [Integrate from verified](#integrate-from-verified)
- [Why verified is stable](#why-verified-is-stable)

### Rule DDR-REMOTE-PULLREQUESTISINGRESS

**A pull request is the authenticated ingress engine, not merely a review.** In the audited regime (`git_workspace: main-via-pr`) the PR is
the one sanctioned way a change enters the server's `main` / `master`: it **authenticates** the author against the server's identity model,
runs the mandatory merge gates, and **performs the merge** itself. Review is one gate a PR can carry, but the load-bearing role is
authentication-plus-merge: the PR is the audited doorway, and closing every other door — no direct push to the protected branch — is what
lets the `git log` audit trail be trusted as complete. Solo `main-direct` is the deliberate single-author exception.

- [PR as authenticated ingress](#pr-as-authenticated-ingress)

## Context

Trunk-based development ([one-living-version](../principles/one-living-version.md), `PDR-ONELIVE-TRUNKBASED`) puts one mainline at the
centre, and [self-service](self-service.md) (`DDR-SELFSERV`) rests its whole audit-and-approval story on that mainline living somewhere
every change is attributed, passes its merge gate, and is recorded. That somewhere is the **server** git remote — the git host's repository
whose branch policy and identity model make those guarantees real. Developer and CI machines are clients that clone and bridge to it.

Two questions arise at that client/server boundary, and this DDR answers both. Reading _from_ the remote: the tip of main is not always safe
to build on, because it can be a dirty HEAD (for example, a tip that entered main-UAT and failed there). Writing _to_ the remote: how does a
change legitimately become part of the audited main at all? The answer to the first is "integrate from the last verified commit"; the answer
to the second is "through a PR, which is the authenticated ingress" — and the two together are what keep the mainline both trustworthy to
build on and honest about its history.

## Decision

Treat the server's main as the authoritative copy of the repository — audited, and bridged by local clones — and its refs and pull requests
as a fact source. Consumers **integrate from the last verified commit, not the remote HEAD**. Changes enter only through a **PR that
authenticates and merges** them. Together these make a dirty HEAD a non-event for everyone downstream and keep the audit trail complete.

### The authoritative remote

`The server remote is the authority`

The guarantees the platform depends on — every change on main attributed, reviewed, and past its merge gate (`DDR-SELFSERV`) — are
server-side facts. A local `main` that has diverged, or a local commit never pushed through the sanctioned path, is working state that has
not yet crossed the boundary.

### Integrate from verified

`Integrate from verified, not HEAD`

Landing is not the same as being verified. The stable sync point is also the commit `main-UAT` takes first, and the rule is uniform across
every consumer of the mainline.

### Why verified is stable

`Why verified is stable and the tip is not`

A commit that reached the verified point is a durable fact no later event un-makes (`PDR-ONELIVE`), so the choice of integration base is a
choice between a stable anchor and a moving one: on the anchor, a later fix to the tip is simply the next thing you pull.

### PR as authenticated ingress

`PR is authenticated ingress, not just review`

Reading a pull request as a review checkpoint undersells it: authentication makes every commit on main attributable to an authenticated
principal. Because the PR is the only door, the mandatory merge gates run on every change, and no one pushes directly to the protected
branch, so the `git log` audit trail is complete. The solo `main-direct` mode is the exception because there the author _is_ the sole
authenticated principal and the doorway collapses to a direct commit; the moment there is more than one author, the PR ingress is what keeps
the mainline audited.

## How this is enforced

- **Server branch policy** — the protected `main` / `master` on the git host's remote admits merges only through a PR, so ingress cannot
  bypass the authenticate-and-merge path (`DDR-REMOTE-PULLREQUESTISINGRESS`).
- **`git_workspace` variant** — `main-via-pr` vs `main-direct` selects the audited-ingress regime; `Sync-GeneratedFile`'s branch guard is
  the local half.
- **The stable sync point** — the BVT-verified server head, as against the dirty HEAD, is the "last verified commit" this DDR tells
  consumers to integrate from; the delivery flow's commit lifecycle defines both.
- **Code review** — a build or workflow that pins its integration base to the remote HEAD rather than the last verified commit, or a process
  that reaches the protected branch outside a PR, is rejected against this DDR.

## Consequences

- A dirty HEAD is a non-event downstream: consumers built on the verified point never reconcile a tip that is later fixed or superseded.
- "What is on main" has one authority — the server remote — so local divergence and un-pushed commits are visibly _not yet_ integrated, not
  a competing truth.
- The audit trail in `git log` is trustworthy as complete, because the PR is the only authenticated doorway into the protected mainline.
- The cost is discipline: consumers must resolve the last-verified commit rather than grab the tip, and every ingress pays the PR's
  authenticate-and-merge-gate step — which is exactly the step that earns the audit and stability guarantees.

## Related

- [one-living-version](../principles/one-living-version.md) (`PDR-ONELIVE`) — trunk-based development and immutable history.
- [self-service](self-service.md) (`DDR-SELFSERV`) — the audit / change-approval guarantees the server remote and PR ingress make real.
