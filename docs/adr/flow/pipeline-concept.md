# ADR: Pipelines — the vendor-neutral CI/CD pipeline concept

## Rules: ADR-FLOW-CD-PIPELINE

### Rule ADR-FLOW-CD-PIPELINE-TYPEPREFIX

A pipeline's filename starts with its type — the first hyphen-delimited token is `cron`, `ci`, `cd`, `cde`, `deploy`, or `input`. No other
prefixes.

- [The name carries the type](#the-name-carries-the-type)

### Rule ADR-FLOW-CD-PIPELINE-EXECUTABLEYAMLEXTENSION

Executable YAML is `.yaml`; config and data that catzc code parses is `.yml`. Never mix the two.

- [The extension tells executable from data](#the-extension-tells-executable-from-data)

### Rule ADR-FLOW-CD-PIPELINE-FLATREADABLEYAML

Keep pipeline YAML flat and readable: a pipeline file reads top-to-bottom as its stages, jobs, and steps, and a reviewer understands what it
does without opening other files.

- [A pipeline reads as a plan](#a-pipeline-reads-as-a-plan)

### Rule ADR-FLOW-CD-PIPELINE-NOSTOREDTOKENS

Never store a token beyond the request that uses it. Acquire the token, build the header, make the call; never cache a token in module or
session state or pass it between functions.

- [A credential lives for one request](#a-credential-lives-for-one-request)

## Context

A pipeline is the automated process that takes a change from a commit towards production: it runs on a trigger, invokes the automation,
passes or fails its gates, and hands its artifacts on. That concept does not depend on the vendor that runs it. The repository holds two
vendor variants of it: the azure devops pipelines under `.ado/pipelines/` (the `ado-pipelines` track) and the GitHub workflows under
`.github/workflows/` (the `github-workflows` track). Both tracks have the track type `pipelines`, the concept
([ADR-DSGN-TRACK-ONETRACKTYPE](../design/tracks.md#rule-adr-dsgn-track-onetracktype)).

The flow domain already decides most of what a pipeline is:

- **What it is for.** Each deployable unit is bound one-to-one to its pipeline, and a pipeline runs only when its unit's globset is touched
  ([ADR-DSGN-TRACK-DEPLOYABLEUNIT](../design/tracks.md#rule-adr-dsgn-track-deployableunit), [durable-sha-globs](durable-sha-globs.md)).
- **Which kind it is.** Every pipeline is one of the six types, keyed together by one immutable tagged artifact
  ([pipeline-types](pipeline-types.md), [cd-discipline-and-promotion-flow](cd-discipline-and-promotion-flow.md)).
- **How it runs the automation.** Every step goes through the runner, so a step is a command a developer can paste into a terminal
  ([pipeline-runner-pattern](pipeline-runner-pattern.md)), and the automation finds out where it runs by detection, never by a flag
  ([pipeline-detection](pipeline-detection.md)).
- **What stops it.** A gate is a check whose verdict decides whether work may proceed
  ([ADR-FLOW-CD-GATEDEFINED](cd-discipline-and-promotion-flow.md#rule-adr-flow-cd-gatedefined)).

This ADR holds the remaining rules that hold for any vendor: how a pipeline file is named, what its extension says, how its YAML reads, and
how long a credential lives inside it. The [ado domain](../ado/pipeline-naming-and-placement.md) binds them for the azure devops pipelines
and the [github domain](../github/github-release.md) for the GitHub workflows.

## Decision

### The name carries the type

A pipeline's type is the first token of its filename (`ci-automation.yaml`, `cd-shared.yaml`), so a flat listing of a pipelines folder is
already an index of every pipeline grouped by type. The type is the one from [pipeline-types](pipeline-types.md); a prefix outside that
closed set is a type the flow model does not have. The vendor ADR decides where the files live
([pipeline-naming-and-placement](../ado/pipeline-naming-and-placement.md) for the azure devops pipelines).

### The extension tells executable from data

`.yaml` is a file the delivery platform executes: a pipeline or a template fragment. `.yml` is configuration or data that catzc code reads
(`azure.yml`, `ado.yml`, a template's `configuration/<env>.yml`). The extension is a one-character classifier a reader and a tool both see
before opening the file, and it holds for every configuration file in the repository.

### A pipeline reads as a plan

A pipeline file lists its stages, a stage its jobs, and a job its steps; each step is a direct task or one template reference. The logic
lives in the automation the runner invokes, and the values come from the catzc configuration system, so the YAML stays declarative. A
reviewer reads the pipeline file alone and knows what it does; a structure that has to be followed through nested templates to be understood
is the failure this rule prevents ([custom-template-discipline](../ado/custom-template-discipline.md) holds the ado template rules).

### A credential lives for one request

A token is the narrowest-lived secret a pipeline holds. The function that calls a service acquires the token, builds the header, and makes
the call; nothing caches the token or hands it to another function, so a token never outlives the request and never leaks into a log, a
variable, or a later step. Which credential is chosen, and how it proves its target, is the vendor ADR's decision
([dual-authentication](../ado/dual-authentication.md) for the azure devops pipelines).

## Consequences

- One rule set names, types, and reads every pipeline the same way, whichever vendor runs it; a vendor ADR adds only what its platform
  needs.
- The vendor-neutral rules are checked where a vendor's gate runs: `Test-Pipelines` checks the type prefix and the extension over the azure
  devops pipelines.
- A rule that names a vendor construct (`extends`, `template:`, the system token, logging commands) belongs to that vendor's domain, not
  here.
