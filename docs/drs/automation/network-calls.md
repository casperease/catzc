# Automation: Network calls only on sanctioned, explicit paths

## Rules: ADR-AUTO-NET

### Rule ADR-AUTO-NET-NODEFAULTPATH

No network call runs on a default path. Importing the modules, running the tests, building, formatting, the quality gates, the prompt and
the agent hooks reach no host beyond the machine; a call that can reach one runs only when a person or a pipeline names the command that
makes it. A tool that can fetch on its own (a resolver, a restore, a module download) runs on a default path only with its offline switch
set.

- [The default path](#the-default-path)
- [Offline switches](#offline-switches)

### Rule ADR-AUTO-NET-SANCTIONEDCLASSES

Every network call belongs to exactly one of six sanctioned classes: `package-install`, `price-data`, `ado-api`, `azure-control-plane`,
`git-remote` or `release-publish`. `azure-control-plane`, `git-remote` and `release-publish` are sanctioned for explicit commands and
pipeline steps only, never for a default path. A call that fits none of them is refused until a decision adds a class; a class is never
inferred from the code that happens to make the call.

- [The classes](#the-classes)

### Rule ADR-AUTO-NET-PACKAGEINSTALL

A `package-install` call fetches a tool, a runtime or a package through a package manager or a verified download, and runs only from a
tooling command (`Install-*`, `Uninstall-*`, the status and advisory commands of the tooling modules, `Test-DependencyAdvisories` among
them) or from the vendoring command `Install-VendorModule`, each on request. A direct download goes through `Save-VerifiedDownload`
(ADR-AUTO-PKGMGR-VERIFYDOWNLOADS), and nothing contacts a package manager outside the tooling system (ADR-AUTO-PKGMGR-NUGETINTOOLINGONLY).

- [The classes](#the-classes)

### Rule ADR-AUTO-NET-PRICEDATA

A `price-data` call reads a public price list, and only the command that refreshes the checked-in price table makes it. Every reader of
prices, the cost model and its tests, reads the checked-in table and never the endpoint.

- [The classes](#the-classes)

### Rule ADR-AUTO-NET-ADOAPI

An `ado-api` call reaches the Azure DevOps REST API through the one request function the Azure DevOps module owns, with the credentials that
module selects, and runs only from an explicit command or a pipeline step that names it.

- [The classes](#the-classes)

### Rule ADR-AUTO-NET-AZURECONTROLPLANE

An `azure-control-plane` call is the `az` CLI acting on a tenant or a subscription. It is a network call in its own class, never folded into
`ado-api`: it runs only from an explicit command or a pipeline step, after the Azure module's session assertions prove the target, and a
build of a template stays offline.

- [The classes](#the-classes)

### Rule ADR-AUTO-NET-GITREMOTE

A `git-remote` call is git or the hosting CLI talking to a remote (fetch, ls-remote, push, a repository create). It runs only from the topic
commands and the publishing commands that name the remote; a git call on a default path reads the local repository alone. A remote that is a
local path is no network call and takes no entry.

- [The classes](#the-classes)

### Rule ADR-AUTO-NET-RELEASEPUBLISH

A `release-publish` call publishes a release outward and cannot be taken back: a package pushed to a feed or a gallery, a release created on
the hosting service, the frozen contracts pushed with it. It runs only in the release pipeline, for a named release version, with the
credentials the pipeline supplies (its token or a repository secret); it never runs locally and is never a default path. The site is
registered `pipeline-only`, and no local command makes such a call.

- [The classes](#the-classes)

### Rule ADR-AUTO-NET-TESTSOFFLINE

A test in the default run never calls out. It mocks the call at its request function, or it reads checked-in data (a recorded response, a
price table, a fixture repository on disk). `Test-Automation` runs L0 to L2 by default; L3, the live tier, runs only when asked with
`-MaxLevel 3`, by a pipeline step or by hand, and only an L3 test may depend on connectivity. A check against a live endpoint is a command
run on request or by a pipeline, or an opt-in L3 test, never part of the default test run.

- [Tests](#tests)

### Rule ADR-AUTO-NET-GENERATEDGUARD

An offline guard config is generated, never kept by hand. The configuration that keeps a tool offline on a default path is written by the
generator of its language from the declared tool versions, and the guard that runs before the tool throws when the generated file is missing
or opened; ADR-AUTO-PKGMGR-NUGETINTOOLINGONLY is the precedent for `dotnet`.

- [Offline switches](#offline-switches)

### Rule ADR-AUTO-NET-SITEREGISTRY

Every call site that can reach the network is one entry in one config registry, `network-calls.yml`, owned by the Base.Execution module: its
key, `<file>#<function or pipeline job>` so one file holds sites of different classes, its class, its trigger and the guard, parameter or
config that keeps it off a default path. A trigger is `on-request`, `pipeline-only`, `offline-guarded` (on a default path with the tool held
offline by a generated guard) or `default-path`, which marks a site that breaks ADR-AUTO-NET-NODEFAULTPATH and stays registered as it is
until its fix lands. The registry is the inventory; this page carries only a summary of it.

- [The registry](#the-registry)

### Rule ADR-AUTO-NET-REGISTRYGATE

A gate checks the registry against the code: every call that matches a network pattern sits in a registered function, and every registered
function still makes the call it is registered for. A new call site lands with its registry entry in the same change.

- [The registry](#the-registry)

## Context

The repository is the configuration record, and the tooling that reads it runs on a developer machine, a pipeline agent and a consumer's
installed bundle. A network call on one of those paths makes the result depend on a host that is not in the commit: a package resolved this
week differs from one resolved next week, an endpoint that is down fails a format run, and a credential in a user profile leaks into a run
that never asked for it. The machine may also be a regulated operations box, where an outbound call is itself a control to account for.

### The default path

`What runs without being asked never leaves the machine`

A default path is everything that runs because some other command ran: the import, the generators it runs, a test run and the language
runners it starts, a build, a format run, the quality gates, the prompt and the hooks. None of these is a decision to reach a host, so none
of them may. A call on request is a decision: a person types `Install-Uv`, or a pipeline step names `Assert-AdoDeploymentHistory`.

### The classes

`Six named classes, each with its own controls`

| Class                 | What it reaches                                   | Runs from                                          |
| --------------------- | ------------------------------------------------- | -------------------------------------------------- |
| `package-install`     | package managers, release feeds, vendored scripts | the tooling commands and the install steps         |
| `price-data`          | the public retail price list                      | the price-table refresh command                    |
| `ado-api`             | the Azure DevOps REST API                         | the Azure DevOps commands and their pipeline steps |
| `azure-control-plane` | a tenant or subscription through `az`             | the deploy, session and resource commands          |
| `git-remote`          | a git remote or the hosting service               | the topic and publishing commands                  |
| `release-publish`     | a package feed, a gallery, a release on the host  | the release pipeline's release job                 |

All six are sanctioned. `azure-control-plane`, `git-remote` and `release-publish` are real network calls of their own: a deploy talks to a
subscription, a topic push talks to a server and a release push talks to a feed, and none is an Azure DevOps API call or a package install,
so each is classified in the open rather than hidden inside another class, and each is limited to the explicit commands and pipeline steps
that name its target, never a default path. `release-publish` is the narrowest: the outbound call is irreversible, so it exists only in the
release pipeline, with pipeline credentials, and never as a local command or a default.

### Offline switches

`A tool that can fetch is told not to`

Several tools fetch on their own when a cache is cold: a Python resolver syncing an environment, a Go module download, a .NET restore, a
`npx` run of a package that is not installed. On a default path each runs with its offline switch, and when the switch lives in a config
file that file is generated from the declared tool versions, so it cannot drift from them and a guard can check it before the tool runs.

### Tests

`A test proves the code, not the network`

A test that calls out fails when the host is down, passes against whatever the host returns that day, and spends its time on the wire. The
call is mocked at its one request function, or the response is checked in, so a test run is fast, repeatable and offline. The default run
stops at L2 for that reason: the live tier, L3, is a choice a pipeline step or a person makes with `-MaxLevel 3`, so connectivity is a
dependency only of a run that asked for it.

### The registry

`One list, checked against the code`

The inventory lives as configuration with one owner because a list in prose drifts from the code it describes; a config can be read by a
gate. The gate searches the code for the network patterns the registry declares and compares the functions it finds with the entries.

## Decision

Network calls run only on explicit paths, each in one of six named classes, each registered in one config, and never on a default path or in
a test.

## Consequences

- Import, tests, builds and format runs behave the same on a disconnected machine as on a connected one.
- A new network call is visible in review as a registry entry with its class and trigger, and the gate fails a call that arrives without
  one.
- A tool's offline mode is a generated config or an environment switch set by the runner, so a cold cache fails loudly instead of fetching.
- A live check of a deployment is a command a pipeline names, so its credentials and its target are chosen on purpose.
