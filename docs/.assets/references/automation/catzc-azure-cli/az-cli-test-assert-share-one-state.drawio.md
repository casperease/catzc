---
catzc:
  immutable:
    with_body_sha: f34f60e47714
    path: docs/.assets/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
    folder: docs/.assets/references/automation/catzc-azure-cli
    name: az-cli-test-assert-share-one-state-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-AUTO-PRELOG#5
      - ADR-AZ-CLI#1
      - ADR-AZ-DATAMOD#4
    links:
      - docs/.assets/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.png
---

# Three az checks: Test and Assert share one state call: the diagram described

```text
A 1588 x 828 diagram, read top to bottom through three side-by-side bands, then one shared band.
Glyphs: 7 code units, 2 named sets, 1 external tool, 1 catzc module frame; 11 flow edges; 9 markers; 2 count chips.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](az-cli-test-assert-share-one-state.drawio.png) draws from the source of the `Catzc.Azure.Cli` module. The
module's reference article embeds it and gives the responsibility in prose.

## At a glance

Cats checks three things about the az CLI session: that it is connected to the right tenant and subscription, that it can access a
subscription, and that its Bicep CLI meets the minimum version. Each check is a `Test-` and `Assert-` pair, and both halves of a pair call
one state function that runs az once and returns a typed state. The `Test-` half returns one field of it; the `Assert-` half throws a
remediation message from the same fields, so the two cannot disagree about what they saw. The config-aware wrappers take a subscription name
and look its ids up in azure.yml first. Every state function runs az through `Invoke-AzCli`.

## Walkthrough

1. **`Get-AzureSubscription`** in `Catzc.Azure` resolves a subscription name to its ids from azure.yml. The config-aware wrappers of the
   connection and access checks call it first.
2. **`Test-AzCliIsConnected`** is the config-aware connection test. After the lookup it delegates to the generic `Test-AzCliConnected`.
3. **`Assert-AzCliIsConnected`** is the config-aware connection assert. After the lookup it calls `Get-AzCliConnectionState` directly, past
   `Assert-AzCliConnected`, and throws its own messages.
4. **`Test-AzCliConnected`** and **`Assert-AzCliConnected`** are the generic pair, taking the subscription and tenant ids as arguments. The
   test returns `connected`; the assert throws on `logged_in` or `connected` being false.
5. **`Get-AzCliConnectionState`** runs `az account show` once and returns a `ConnectionState`: logged in, connected, and the expected and
   actual tenant and subscription.
6. **`SubscriptionAccessState`** is the access check's set of five functions: `Test-AzCliCanAccess` and `Assert-AzCliCanAccess` (the
   config-aware wrappers), `Test-AzCliSubscriptionAccessible` and `Assert-AzCliSubscriptionAccessible` (the generic pair), and
   `Get-AzCliSubscriptionAccessState`, which probes the subscription with a read-only `az account list-locations`.
7. **`BicepState`** is the Bicep check's set of three functions: `Test-AzCliBicep`, `Assert-AzCliBicep` and the private
   `Get-AzCliBicepState`, which runs `az bicep version` and compares it with azure.yml's `bicep_min_version`. It has no config-aware
   wrapper, so the set starts at the pair row.
8. **`Invoke-AzCli`** is the one runner every state function uses. It asserts the locked az version and runs the command.
9. **`az`** is the Azure CLI itself, the vendor tool behind every check.

## Reading path

Start at marker 1, the `Get-AzureSubscription` bar inside the `Catzc.Azure` frame at the top. Drop into the CONNECTION band: the two
wrappers at markers 2 and 3 point up to that bar and down to the pair row. Marker 2 goes down to `Test-AzCliConnected`; marker 3's edge runs
down the band's right side, past `Assert-AzCliConnected`, into `Get-AzCliConnectionState` at marker 5. Then read across to the ACCESS and
BICEP bands, each a single named set. All three state calls drop into `Invoke-AzCli` in the SHARED band, which calls `az` below it.

## Glyphs

| Glyph                      | Kind          | Band          | Marker |
| -------------------------- | ------------- | ------------- | ------ |
| `Catzc.Azure`              | catzc module  | none (top)    | —      |
| `Get-AzureSubscription`    | code unit     | in the frame  | 1      |
| `Test-AzCliIsConnected`    | code unit     | CONNECTION    | 2      |
| `Assert-AzCliIsConnected`  | code unit     | CONNECTION    | 3      |
| `Test-AzCliConnected`      | code unit     | CONNECTION    | 4      |
| `Assert-AzCliConnected`    | code unit     | CONNECTION    | —      |
| `Get-AzCliConnectionState` | code unit     | CONNECTION    | 5      |
| `SubscriptionAccessState`  | named set     | ACCESS        | 6      |
| `BicepState`               | named set     | BICEP         | 7      |
| `Invoke-AzCli`             | code unit     | SHARED        | 8      |
| `az`                       | external tool | none (bottom) | 9      |

The access set is tall, spanning the wrapper, pair and state rows; the bicep set spans only the pair and state rows. A count chip reading
`5` sits on the bottom-right corner of the access set, and one reading `3` on the bicep set. `Get-AzureSubscription`,
`Get-AzCliConnectionState` and `Invoke-AzCli` are wide bars so that several vertical edges can meet them.

## Edges

Every edge is a flow edge meaning "calls", drawn as a straight vertical line. Each is backed by a call site in the source.

| From                       | To                         | Call site                                              |
| -------------------------- | -------------------------- | ------------------------------------------------------ |
| `Test-AzCliIsConnected`    | `Get-AzureSubscription`    | `Test-AzCliIsConnected.ps1`                            |
| `Assert-AzCliIsConnected`  | `Get-AzureSubscription`    | `Assert-AzCliIsConnected.ps1`                          |
| `SubscriptionAccessState`  | `Get-AzureSubscription`    | `Test-AzCliCanAccess.ps1`, `Assert-AzCliCanAccess.ps1` |
| `Test-AzCliIsConnected`    | `Test-AzCliConnected`      | `Test-AzCliIsConnected.ps1`                            |
| `Assert-AzCliIsConnected`  | `Get-AzCliConnectionState` | `Assert-AzCliIsConnected.ps1`                          |
| `Test-AzCliConnected`      | `Get-AzCliConnectionState` | `Test-AzCliConnected.ps1`                              |
| `Assert-AzCliConnected`    | `Get-AzCliConnectionState` | `Assert-AzCliConnected.ps1`                            |
| `Get-AzCliConnectionState` | `Invoke-AzCli`             | `Get-AzCliConnectionState.ps1`                         |
| `SubscriptionAccessState`  | `Invoke-AzCli`             | `Get-AzCliSubscriptionAccessState.ps1` (two calls)     |
| `BicepState`               | `Invoke-AzCli`             | `private/Get-AzCliBicepState.ps1`                      |
| `Invoke-AzCli`             | `az`                       | `Invoke-AzCli.ps1`, through `Invoke-Executable`        |

The three edges into `Get-AzureSubscription` point upward, the only upward edges on the canvas. No edge enters `Assert-AzCliConnected`.

## Legend

The legend panel spans the bottom of the drawing area in four columns:

- code unit
- named set
- external tool
- catzc module
- flow: calls
- marker: a Walkthrough step
- count chip: functions in the set

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AZ-CLI#1, ADR-AZ-DATAMOD#4, ADR-AZ-CUSTOMER,
ADR-AUTO-FAILFAST, ADR-AUTO-ENTERP and ADR-AUTO-PRELOG#5: the rules the drawn code cites. Source-lens slides carry no minimaps.

## Where the code and the ADR differ

The ADRs and the drawn code don't differ. One code comment does: the comment of `Assert-AzCliConnected` says the config-aware
`Assert-AzCliIsConnected` delegates to it, while `Assert-AzCliIsConnected` calls `Get-AzCliConnectionState` directly and repeats the throw.
The diagram draws the code, and the comment of `Assert-AzCliIsConnected` itself states it correctly.
