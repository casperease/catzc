# ADR: Az CLI session verification — three layers, and verify is not connect

## Rules: ADR-AZ-SESSION

### Rule ADR-AZ-SESSION:1

Keep three az concerns in separate functions and do not collapse them: **availability** (`Assert-Tool 'AzCli'` in `Catzc.Tooling.Core` — is
`az` on PATH at the locked `tools.yml` version), **by-args verification** (`Assert-AzCliConnected` / `Test-AzCliConnected` in
`Catzc.Azure.Cli` — is the session set to a subscription / tenant supplied as GUIDs, with no `azure.yml`), and **config-aware verification**
(`Assert-AzCliIsConnected` / `Test-AzCliIsConnected` in `Catzc.Azure.Cli` — is the session set to the subscription _named_ in `azure.yml`).

- [The three layers](#the-three-layers)

### Rule ADR-AZ-SESSION:2

Verify is not connect. The `Assert-*` / `Test-*` functions are read-only: they check the session against what config says is correct and, on
failure, name the `az login` / `az account set` to run. The actual connecting is `Connect-AzCli` (in `Catzc.Azure.Cli`); a verification
function never logs in.

- [Verify is not connect](#verify-is-not-connect)

### Rule ADR-AZ-SESSION:3

One shared comparison source. `Get-AzCliConnectionState` runs `az account show` once and both wrappers read it — `Test-` returns a bool,
`Assert-` throws — so they cannot drift. A config-aware wrapper resolves identity from config (`Get-AzureSubscription`) and then delegates
to this primitive instead of re-implementing the comparison.

- [One shared comparison source](#one-shared-comparison-source)

### Rule ADR-AZ-SESSION:4

Config defines what "correct" means, and those config keys are required inputs. Whether the session is "connected to the right place" is
decided solely by config — `azure.yml` subscription + tenant, `ado.yml` organization + tenant — never by the presence of a credential or
token alone. Every auth path proves itself against that config, so the keys that define correctness are mandatory, not optional.

- [Config defines correct](#config-defines-correct)

### Rule ADR-AZ-SESSION:5

The **reverse lookup** is the fourth layer: `Get-AzCliSessionSubscription` (in `Catzc.Azure.Cli`) reads the session's active subscription
(`Get-CurrentAzSubscription`) and resolves its GUID to the declared `azure.yml` identity — name, customer, tenant — throwing when the
session targets a subscription azure.yml does not declare. It makes the session usable as a **selector** (the deploy target follows the
service connection) while config stays the authority on what exists; it is read-only like every verification (ADR-AZ-SESSION:2), and the
`-SubscriptionIdAssertIs` guard on the deploy surface is its explicit pin (see
[data-model](../azure/azure-data-model.md#rule-adr-az-datamod7)).

- [The reverse lookup](#the-reverse-lookup)

## Context

Working with `az` involves three genuinely different questions that are easy to conflate: is the tool installed, is the session pointed at a
subscription I name by its raw GUID, and is the session pointed at the subscription my configuration says this work targets. Collapsing them
produces functions that "check the connection" but secretly depend on `azure.yml`, or that quietly log you in as a side effect of a check —
both of which make failures hard to reason about and couple modules that should not depend on each other.

This ADR records how the az-session functions are layered. It complements [prefer-az-cli](powershell/prefer-az-cli.md) (why `az` over the Az
PowerShell modules) and [dual-authentication](../pipelines/dual-authentication.md) (how an ADO token is selected and proven against
`ado.yml`).

## Decision

### The three layers

- **Availability** — `Assert-Tool 'AzCli'` (`Catzc.Tooling.Core`) confirms `az` is on PATH at the locked version. Tool presence only; it
  knows nothing about login or subscriptions.
- **By-args verification** — `Assert-AzCliConnected` / `Test-AzCliConnected` (`Catzc.Azure.Cli`) take a subscription and/or tenant **GUID**
  and compare the live session against it. They are `azure.yml`-free, so any module (e.g. `Catzc.Azure.DevOps`) can use them without
  depending on the templating configuration.
- **Config-aware verification** — `Assert-AzCliIsConnected` / `Test-AzCliIsConnected` (`Catzc.Azure.Cli`) take a subscription **name** (a
  key in `azure.yml`), resolve it to its subscription + tenant GUIDs via `Get-AzureSubscription`, and then delegate to the by-args layer.

### Verify is not connect

A check answers "are we connected to the config-defined correct target?" and nothing more. On a mismatch it throws (or returns `$false`)
with the exact remediation command — it never performs the login itself. Logging in is `Connect-AzCli`'s job. This keeps a check safe to
call anywhere (it has no side effects) and keeps the connecting logic in one place.

### One shared comparison source

`Get-AzCliConnectionState` is the single implementation of the comparison: it runs `az account show`, then reports `logged_in`, `connected`,
and the expected-vs-actual subscription/tenant. `Test-` and `Assert-` are thin wrappers over it, and the config-aware functions resolve
identity then call it — so there is exactly one place that decides what "connected" means, and the bool and the throw can never disagree.

### The reverse lookup

The forward layers answer "is the session pointed where config says it should be?". The reverse lookup answers the complementary question —
"WHERE is the session pointed, in config terms?" — and is what lets the session act as the deploy-target selector: in a pipeline the service
connection logs the session into one subscription, and `Get-AzCliSessionSubscription` maps that back to the declared `azure.yml` identity
(name, customer, tenant) so the rest of the platform reasons in config vocabulary. A session pointed at an undeclared subscription throws —
config defines what exists (ADR-AZ-SESSION:4), so an unknown target is an error, never a fallback. The lookup is read-only
(ADR-AZ-SESSION:2); the explicit pin against mis-wiring is the deploy surface's `-SubscriptionIdAssertIs` guard, mandatory in pipelines
([data-model](../azure/azure-data-model.md#rule-adr-az-datamod7)).

### Config defines correct

The configuration is the sole authority on the target: `azure.yml` says which tenant and subscription are correct; `ado.yml` says which
organization and tenant. A credential that authenticates somewhere is not evidence it authenticated to the _right_ somewhere. Because the
correctness check is config-driven, the config keys that express it (tenant, subscription, organization) are required — treating them as
"only some paths need this" is backwards.

## How this is enforced

- **`Assert-Tool 'AzCli'`** (`Catzc.Tooling.Core`) owns availability — the az _binary_ and its `tools.yml` version lock; **`Connect-AzCli`**
  (`Catzc.Azure.Cli`) owns connecting, alongside the rest of the az _session_ surface (the `Invoke-AzCli` runner, subscription selection,
  extension checks, and the verification functions below). No verification function logs in.
- **`Get-AzCliConnectionState`** (`Catzc.Azure.Cli`) is the shared comparison; `Assert/Test-AzCliConnected` (by GUIDs) and
  `Assert/Test-AzCliIsConnected` (by `azure.yml` subscription name, via `Get-AzureSubscription`) all route through it.
- **`Get-AzCliSessionSubscription`** (`Catzc.Azure.Cli`) owns the reverse lookup (session GUID → declared identity), built on
  `Get-CurrentAzSubscription`; the deploy path (`Get-BicepDeploymentContext`, `Deploy-Bicep`, `Set-BicepTrackingTagSet`) consumes it and is
  the mock seam tests isolate.
- **Code review** keeps the layers apart: a session check that reads `azure.yml` belongs in the config-aware layer, a generic one in the
  by-args layer, and neither belongs in `Catzc.Tooling.Core`.

## Consequences

- A peer module can verify the session by GUID without taking a dependency on the templating configuration.
- The bool and throwing checks always agree, because they share one comparison.
- A check is always safe to call — it never changes session state. The one thing that logs you in is named, separately, in the error it
  throws.
- The cost is more small functions instead of one "check and fix" helper — which is the point: each answers one question.

## Dora explains

DORA's research links robust authentication and authorization practices to reliable, secure deployments. Layering session verification and
keeping concerns separate enables safe, auditable automation while maintaining module independence.

- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — layered verification ensures sessions are authenticated to the
  correct subscription before any deployment automation proceeds.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — separating by-args and config-aware verification allows
  modules to verify session state without depending on templating configuration.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — clean session verification functions enable safe,
  automated deployments with proper auth checks at each layer.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
