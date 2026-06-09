# Catzc.Azure.Cli

The Azure CLI module. It **encapsulates every interaction with the `az` CLI** — issuing commands, establishing and selecting the session,
and verifying that the session points where configuration says it should. It is the single boundary the whole platform runs `az` through.
What it deliberately does **not** own is the az _binary_: installing it lives in [Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md)
(`Install-AzCli`) and locking its version in [Catzc.Tooling.Core](catzc-tooling-core.md) (`Assert-Tool`, `tools.yml`). This module owns
everything you _do_ with `az` once it is installed. The verify-vs-connect split is the subject of
[az-session-verification](../../adr/automation/az-session-verification.md).

## Domains

| Domain   | Area          | Name                                                                               |
| -------- | ------------- | ---------------------------------------------------------------------------------- |
| domain:1 | invocation    | [Azure CLI invocation](#domain1--azure-cli-invocation)                             |
| domain:2 | connect       | [Session connect and disconnect](#domain2--session-connect-and-disconnect)         |
| domain:3 | context       | [Subscription selection and context](#domain3--subscription-selection-and-context) |
| domain:4 | inspect       | [Connection-state inspection](#domain4--connection-state-inspection)               |
| domain:5 | verify-args   | [By-args session verification](#domain5--by-args-session-verification)             |
| domain:6 | verify-config | [Config-aware session verification](#domain6--config-aware-session-verification)   |
| domain:7 | access        | [Subscription access checks](#domain7--subscription-access-checks)                 |
| domain:8 | bicep         | [Bicep CLI readiness](#domain8--bicep-cli-readiness)                               |

### domain:1 — Azure CLI invocation

The single asserted entry point every `az` command in the platform flows through. It version-checks the CLI against the locked `tools.yml`
version (`Assert-Tool 'az_cli'`), disables dynamic extension install so a missing-extension command fails fast instead of hanging on an
invisible prompt, logs the exact command, and returns either a structured result or — in dry-run — the command string for a test to assert
on. Extension presence checks belong here too: they are how a command that needs an `az` extension fails with a clear remediation instead of
a cryptic argument error. This is the encapsulation the module exists for — no other module issues raw `az`.

### domain:2 — Session connect and disconnect

Establishing and tearing down the authenticated `az` session: signing in (interactively, by device code, by service principal, or by managed
identity) and signing out. This is a state-changing action — the _connect_ side of "verify is not connect." It asserts the binary is present
(`Assert-Tool`) but knows nothing about whether the session targets the right place; that judgement is the verification domains below.

### domain:3 — Subscription selection and context

Choosing which subscription the session acts against, and running work pinned to a chosen one. This domain reads the active subscription,
switches it, and runs a scriptblock against a selected subscription with the surrounding context restored afterward. It changes session
_selection_ only — never credentials.

### domain:4 — Connection-state inspection

The single shared comparison: run the live session's account query once and report whether it is logged in, what subscription and tenant it
is on, and how that compares to what was expected. Every verification in this module reads from this one source, so the throwing and
querying forms can never disagree.

### domain:5 — By-args session verification

Confirming the session matches a subscription and/or tenant supplied as raw GUIDs. This layer knows nothing about the identity model in
`azure.yml`, so any module can use it without taking a dependency on the templating configuration.

### domain:6 — Config-aware session verification

Confirming the session matches the subscription _named_ in the identity model — it resolves that name to its GUIDs (through
[Catzc.Azure](catzc-azure.md)) and then delegates to the by-args layer. This is the verification a deployment uses, because it checks
against what configuration says is correct.

### domain:7 — Subscription access checks

Confirming the signed-in identity can actually _reach_ a subscription — that it is listed and accessible — as opposed to merely being the
currently-selected one. This distinguishes "authenticated somewhere" from "able to operate here."

### domain:8 — Bicep CLI readiness

Confirming the Bicep CLI is present at or above the minimum version the estate requires, before a build or deploy relies on it.

## What the module does

The module is the platform's `az` boundary, and it is built as a stack with one foundation. Domain 1 is that foundation in the literal
sense: `Invoke-AzCli` is the one place a real `az` process is launched, and everything else here — connecting, selecting, inspecting,
verifying — runs through it or through the connection-state primitive it feeds. Pulling the runner into this module (rather than leaving it
among the generic tool wrappers) is what lets "use the az CLI" be one cohesive responsibility: the version lock, the extension-install
guard, and the command log are inherited by every caller for free, and no other module ever issues raw `az`.

Two design rules shape the verification half. First, **verify is not connect**: domains 2 and 3 _act_ (log in, select a subscription);
domains 4–8 only _read_ and, on a mismatch, name the command the operator should run — they never run it themselves, so a verification is
always safe to call anywhere. Second, **configuration defines "correct"**: whether a session is pointed at the right place is decided by
what the identity model says, not by the mere presence of a credential. Domains 5 and 6 are two heights of the same check — domain 5
compares against GUIDs a caller supplies, domain 6 against an identity resolved from `azure.yml` by name — and domain 6 is literally domain
5 with the names looked up first. Keeping them separate is what lets a module with no business reading `azure.yml` still verify a session by
GUID.

The split with the Tooling group is the deliberate counterpart to all of this: [Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md) owns
the az **binary** (install and uninstall) and [Catzc.Tooling.Core](catzc-tooling-core.md) the `tools.yml` version lock asserted by
`Assert-Tool`, while this module owns the az **session**. The one tie back is that `Invoke-AzCli` and the connect functions call
`Assert-Tool 'az_cli'` (from [Catzc.Tooling.Core](catzc-tooling-core.md)) — a single, version-locking dependency, not a reimplementation of
tool management.

## Division

The module's public functions, sorted into the domains above.

| Domain                                        | Function                             |
| --------------------------------------------- | ------------------------------------ |
| domain:1 — Azure CLI invocation               | `Invoke-AzCli`                       |
|                                               | `Assert-AzCliExtension`              |
|                                               | `Test-AzCliExtension`                |
| domain:2 — Session connect and disconnect     | `Connect-AzCli`                      |
|                                               | `Disconnect-AzCli`                   |
| domain:3 — Subscription selection and context | `Set-AzCliSubscription`              |
|                                               | `Get-CurrentAzSubscription`          |
|                                               | `Set-CurrentAzSubscription`          |
|                                               | `Invoke-InSubscription`              |
| domain:4 — Connection-state inspection        | `Get-AzCliConnectionState`           |
| domain:5 — By-args session verification       | `Assert-AzCliConnected`              |
|                                               | `Test-AzCliConnected`                |
| domain:6 — Config-aware session verification  | `Assert-AzCliIsConnected`            |
|                                               | `Test-AzCliIsConnected`              |
| domain:7 — Subscription access checks         | `Get-AzCliSubscriptionAccessState`   |
|                                               | `Assert-AzCliCanAccess`              |
|                                               | `Test-AzCliCanAccess`                |
|                                               | `Assert-AzCliSubscriptionAccessible` |
|                                               | `Test-AzCliSubscriptionAccessible`   |
| domain:8 — Bicep CLI readiness                | `Assert-AzCliBicep`                  |
|                                               | `Test-AzCliBicep`                    |
