# Catzc.Azure.DevOps.BuildValidation

The build-validation policy module. It owns the server-side pre-commit half of a deployable unit's CI binding: the ADO build-validation
branch policies that queue a unit's pipeline on the guarded branch, each tied to its globset by path-filtering on the globset's sha-marker
file (see [pipeline-types](../../adr/pipelines/pipeline-types.md) and [durable-sha-globs](../../adr/pipelines/durable-sha-globs.md)). The
local `build-validation.yml` is the source of truth and the module converges the ADO project to it
([everything-as-code](../../adr/principles/everything-as-code.md)). What it deliberately does **not** own is the globsets themselves
([Catzc.Base.Globs](catzc-base-globs.md)) or the pipelines the policies queue — it binds the two together on the server, nothing more.

## Domains

| Domain   | Area      | Name                                                        |
| -------- | --------- | ----------------------------------------------------------- |
| domain:1 | reconcile | [Policy reconciliation](#domain1--policy-reconciliation)    |
| domain:2 | inventory | [Policy inventory](#domain2--policy-inventory)              |

### domain:1 — Policy reconciliation

Converging the ADO project's build-validation policies to the local config. Registering binds a declared globset's sha-marker file as the
path filter of a policy that queues the resolved pipeline on the guarded branch — creating a missing policy, updating a drifted one in
place (matched by pipeline definition + branch, so a marker-path or display-name change never duplicates), and leaving a current one alone
([idempotent-state-functions](../../adr/automation/idempotent-state-functions.md)). Everything defaults from config: the pipeline resolves
from the entry, then the globset's own `pipeline:` annotation in `globs.yml`; the branch and the blocking/display-name bits from
`build-validation.yml`. The sync form runs the whole registry in one idempotent pass, and unregistering removes a globset's policy — a
reported no-op when none exists. Every mutation supports `-DryRun`, returning the planned Create/Update/Unchanged action without touching
the server.

### domain:2 — Policy inventory

Reading the repository's build-validation policies as they stand on the server. The query returns one object per policy — id, display
name, guarded branch, path filters, the pipeline definition it queues, the blocking/enabled bits, and the raw configuration — optionally
scoped to one branch. Read-only by contract: observing the server state is a separate concern from converging it, so a check never mutates.

## What the module does

The module makes the server-side pre-commit gate a function of version control. A build-validation policy is ADO's mechanism for "this PR
must build green before it merges", and which policies exist — for which units, queuing which pipelines, on which branch — is exactly the
kind of state that drifts when it lives only in the ADO UI. Here it lives in `build-validation.yml`: each entry names a declared globset,
and the policy's path filter is that globset's sha-marker file, so the policy fires precisely when the unit's durable SHA changes — the
registration-only trigger discipline of [durable-sha-globs](../../adr/pipelines/durable-sha-globs.md), applied to the one trigger surface
that lives server-side rather than in the repository.

Reconciliation is idempotent end to end: `Sync-AdoBuildValidations` can run on a schedule or after any registry edit, and a converged
project is a no-op pass. Globset existence is checked at runtime and by an integrity test — never at config load, so reading the registry
stays hermetic (the same pattern as the customer catalogue,
[customer-model](../../adr/azure/customer-model.md#rule-adr-customer3)). The REST calls authenticate through the dual-authentication
precedence ([dual-authentication](../../adr/pipelines/dual-authentication.md)) like the rest of the ADO surface.

## Division

The module's public surface, sorted into the domains above.

| Domain                           | Function                       |
| -------------------------------- | ------------------------------ |
| domain:1 — Policy reconciliation | `Sync-AdoBuildValidations`     |
|                                  | `Register-AdoBuildValidation`  |
|                                  | `Unregister-AdoBuildValidation` |
| config                           | `build-validation.yml`         |
| domain:2 — Policy inventory      | `Get-AdoBuildValidations`      |
