# ADR: Custom template discipline — when and how to use ADO templates

## Rules: ADR-TEMPLATE

### Rule ADR-TEMPLATE:1

Default to a self-contained pipeline; do not create templates speculatively. Extract a template only when a fragment is genuinely reusable,
proven by the rule of three (at least three real pipelines need the same fragment).

- [What goes wrong](#what-goes-wrong)
- [Anti-patterns](#anti-patterns)

### Rule ADR-TEMPLATE:2

Template paths are always absolute, rooted at the repository root (`template: /pipelines/path/to/template.yaml`). Never use relative paths.

- [Anti-patterns](#anti-patterns)

### Rule ADR-TEMPLATE:3

Templates encapsulate pipeline concerns only (task selection, service connection wiring, gates, pool selection, checkout, token mapping,
artifacts). They must not carry automation logic, configuration resolution, business rules, or string formatting.

- [What templates are good at](#what-templates-are-good-at)
- [What goes wrong](#what-goes-wrong)

### Rule ADR-TEMPLATE:4

Template parameters are either ADO controls or meta selection criteria (customer, environment, subscription type). The looked-up values the
automation layer can derive from those keys must not be pipeline parameters.

- [Pipeline parameters are selection criteria](#pipeline-parameters-are-selection-criteria)
- [The parameter needle-through problem](#the-parameter-needle-through-problem)

### Rule ADR-TEMPLATE:5

Minimize nesting depth. A pipeline file calls a step or job template directly; one level of inclusion is normal, two is a warning sign,
three is a design problem. A template that exists only to forward parameters should not exist.

- [What goes wrong](#what-goes-wrong)
- [Anti-patterns](#anti-patterns)

### Rule ADR-TEMPLATE:6

Variables are for ADO plumbing (build numbers, artifact paths, output variables, conditional expressions). Do not use variables to transport
script configuration — that comes from the automation layer's configuration system.

- [Variables are not configuration](#variables-are-not-configuration)

### Rule ADR-TEMPLATE:7

Keep YAML flat and readable: a pipeline file reads top-to-bottom as stages, jobs, and steps, and a reviewer understands what it does without
opening other files.

- [What to use instead](#what-to-use-instead)

## Context

Azure DevOps YAML templates (`template:` references) allow pipelines to share structure — stages, jobs, steps, and variables. They are a
powerful reuse mechanism for pipeline concerns. They are also frequently misused as a general-purpose abstraction layer, wrapping automation
logic in YAML indirection that makes pipelines opaque, brittle, and impossible to review.

This ADR defines when templates add value, when they cause harm, and what to use instead.

### What templates are good at

Templates are the right tool when they encapsulate **pipeline-level concerns** — things that only ADO knows about:

- **Security boundaries.** Service connections, environment approvals, token mapping, managed identity selection.
- **Agent provisioning.** Pool selection, container jobs, demands, agent capabilities.
- **Step wiring.** Checkout configuration, artifact publishing, cache keys.
- **Organizational compliance.** Mandated steps (security scanning, audit logging) that must appear in every pipeline.

The step template in `invoke-automation.yaml` is a good example: it wires up the runner, selects the task type based on `Mode`, maps the
system token when needed, and sets the display name. These are all ADO concerns that the PowerShell automation layer cannot handle.

### What goes wrong

Problems start when templates are used to encode **automation logic** or **configuration values** — when the YAML layer tries to be the
brain instead of the switchboard.

Note the distinction between two kinds of configuration values. **Orchestration configuration** — values that ADO itself consumes to control
flow — is legitimate YAML-layer state. Agent pool names, stage conditions, deployment environment names, service connection identifiers,
variable group references: these exist because ADO needs them to decide _what runs where and when_. They belong in pipeline files and
variable templates. **Automation configuration** — values consumed by scripts to do their actual work (IaC parameters, resource names,
feature flags, connection strings, customer-specific settings) — does not belong in ADO at all. It is not passed through template
parameters, not stored in variable groups, and not mapped into `$env:` variables. It lives in the automation layer's configuration system,
looked up by meta selection criteria at runtime. The pipeline is a thin orchestrator — its job is to decide _what runs where and when_, not
to carry the data that scripts need to do their work.

**Template wrapping.** A template that wraps a single step with ten parameters is not simplifying anything — it is adding a layer of
indirection that the reader must open and mentally inline. If the wrapped step is a runner invocation, the template is overhead. The caller
could invoke the runner directly.

**Deep nesting.** Template A calls template B calls template C. Each layer passes parameters through. The pipeline definition is now spread
across four files. A reviewer opening the PR sees a change to template B and has no way to know which pipelines are affected without tracing
every consumer of A, B, and C. ADO has no built-in validation or expansion tooling for templates [^1] — the only way to understand what runs
is to mentally inline the entire tree.

**Parameter explosion.** A deeply nested template tree means every parameter must be declared at each layer and threaded through. A template
with 15 parameters — most of which it does not use itself but passes to an inner template — is not an abstraction. It is a bureaucratic form
that adds boilerplate, merge-conflict surface, and cognitive load without providing any value to the reader. Microsoft provides
`templateContext` [^2] to reduce parameter proliferation between template layers — a platform-level acknowledgment that parameter explosion
is a recognized, widespread problem.

### Pipeline parameters are selection criteria

Pipeline parameters serve as **meta-level selection criteria** — they identify _which_ customer, environment, or subscription type the
pipeline run targets. These are values like `Customer`, `Environment` — high-level keys that the user selects when queuing a run, and that
templates can legitimately pass through to the automation layer.

These meta parameters are good and intended:

```yaml
# pipeline.yaml — meta parameters as selection criteria
parameters:
  - name: Customer
    type: string
  - name: Environment
    type: string
    values: [dev, preprod, production]

steps:
  - template: /pipelines/steps/invoke-automation.yaml
    parameters:
      RunCommand: "Deploy-Service -Customer ${{ parameters.Customer }} -Environment ${{ parameters.Environment }}"
      Mode: azcli
      ServiceConnection: sc-${{ parameters.Environment }}
```

The pipeline passes two selection criteria — a customer and an environment — and one ADO concern (the service connection). The automation
layer uses these keys to look up everything it needs from its own configuration.

### The parameter needle-through problem

Problems start when the pipeline passes values that **the automation layer can derive from the selection criteria**.

```yaml
# pipeline.yaml — BAD: needling config details through the template layer
- template: /pipelines/templates/deploy-service.yaml
  parameters:
    customer: contoso
    environment: production
    serviceConnection: sc-prod
    appName: my-app
    configPath: config/prod.json
    featureFlags: "--enable-v2 --disable-legacy"
    healthCheckUrl: https://my-app.example.com/health
    warmupPaths: "/api/status,/api/config"
    rollbackOnFailure: true
    notificationChannel: "#deploys"
```

The template receives ten parameters. It uses two itself (`environment`, `serviceConnection`) — both ADO concerns. It passes the other eight
to an inner template or directly to a script. Those eight are not ADO concerns — they are configuration details that the automation layer
can resolve from the customer and environment keys alone.

If each customer has an assigned list of environments, app names, feature flags, and health-check URLs, then those values live in the
automation layer's configuration system. Needling them through template parameters means every change to config requires a YAML change,
every template in the chain must declare and forward the parameter, and the pipeline definition becomes a fragile mirror of data that
already exists in a better place.

The correct version:

```yaml
# pipeline.yaml — GOOD: meta parameters only
- template: /pipelines/templates/deploy-service.yaml
  parameters:
    customer: ${{ parameters.Customer }}
    environment: ${{ parameters.Environment }}
    serviceConnection: sc-${{ parameters.Environment }}
```

```yaml
# /pipelines/templates/deploy-service.yaml — the template itself
parameters:
  - name: customer
    type: string
  - name: environment
    type: string
  - name: serviceConnection
    type: string

steps:
  - template: /pipelines/steps/invoke-automation.yaml
    parameters:
      RunCommand: "Deploy-Service -Customer ${{ parameters.customer }} -Environment ${{ parameters.environment }}"
      Mode: azcli
      ServiceConnection: ${{ parameters.serviceConnection }}
```

Three parameters — two meta selection criteria and one ADO concern. Same template, but the seven config details are gone. The template
passes the meta keys into the `RunCommand` string and wires the service connection. Nothing else. The automation layer resolves app names,
config paths, feature flags, and everything else from its own configuration using the customer and environment as lookup keys.

### Variables are not configuration

ADO pipeline variables have a specific purpose: **communication between ADO constructs** — passing values between steps, jobs, and stages.
Setting build numbers. Controlling conditional expressions. Mapping tokens.

They are not a general-purpose configuration system. When variables carry application configuration — connection strings, feature flags,
version numbers, deployment targets — the YAML layer becomes a configuration store that competes with the automation layer's own config
files. Values are defined in YAML, overridden in variable groups, re-overridden in variable templates, and passed to scripts through `$env:`
— a chain that is impossible to trace without opening every file in the variable resolution order. Variables are also mutable by design —
upstream steps can silently modify downstream values — making them an unreliable transport for configuration that scripts depend on being
stable. Variable groups make this worse: they are not code, not version-controlled, and have no built-in change tracking (see
[everything-as-code](../principles/everything-as-code.md)). The only legitimate use for a variable group is secrets — and only when no
proper secret store (such as Key Vault) is available.

Script configuration belongs in the automation layer. The pipeline's job is to collect the meta-level selection criteria — customer,
environment, subscription type — and pass them to the script. Everything the script needs beyond those keys, it resolves itself.

## Decision

Templates are used only for pipeline-level concerns. Automation logic, configuration, and business rules live in the automation layer and
are invoked through the runner pattern (see [pipeline-runner-pattern](pipeline-runner-pattern.md)). And even for those concerns, a template
is the **exception, not the default**: the default is a self-contained pipeline of a page or two of inline YAML, composed directly. A
template is extracted only when a fragment is proven to be genuinely, generally reusable — never created speculatively.

### Anti-patterns

**The speculative template.** A fragment extracted because it _might_ be reused, or to keep a pipeline "DRY," before three real pipelines
actually need the same thing. It trades a readable inline page for a layer of indirection against a reuse that may never arrive. Leave the
YAML inline until the third real consumer exists, then extract.

**The parameter pass-through template.** A template that declares ten parameters and passes eight of them unchanged to an inner template or
a script. This template adds indirection without value. Inline the step or call the runner directly.

**The variable-configured pipeline.** A pipeline that defines thirty variables at the top — half in the YAML, half in a variable group — and
maps them into script environment variables. The script reads `$env:DatabaseServer`, `$env:FeatureFlags`, `$env:AppVersion`. These values
should come from the automation layer's configuration, not from ADO variables.

**The template-per-service pattern.** A `deploy-api.yaml`, `deploy-worker.yaml`, `deploy-frontend.yaml` where each template is identical
except for two parameter defaults. This is not reuse — it is copy-paste with indirection. Use a single runner invocation with different
command arguments instead.

**The relative-path chain.** `template: ../shared/steps.yaml` from within a template that was itself included via a relative path. The
resolution context shifts at each level, making the actual file path a puzzle. Absolute paths eliminate this entirely.

### What to use instead

- **The runner pattern** for all automation logic. Pass a `RunCommand` string that a developer can paste into a terminal after
  `.\importer.ps1`. See [pipeline-runner-pattern](pipeline-runner-pattern.md).

- **The automation layer's configuration system** for all values the script needs. Configuration files, structured lookups keyed by meta
  parameters (customer, environment, subscription type) — these are version-controlled, testable, and independent of the pipeline.

- **Flat pipeline files** with direct step template references. A stage lists its jobs. A job lists its steps. Each step is either a direct
  task or a single-level template reference. The pipeline reads as a plan, not a maze.

## Consequences

- Pipeline YAML is thin and declarative. Reviewers can understand the flow from the pipeline file alone.
- Template parameter lists stay short (2-5 parameters), covering only ADO-level decisions.
- Configuration lives in one place (the automation layer), not split between YAML variables, variable groups, and template parameters.
- Moving files does not break template references, because all paths are absolute.
- Nested template trees are eliminated, removing the parameter pass-through boilerplate and the mental inlining tax.
- New pipelines are easy to write: pick the step template, write the `RunCommand`, set the `Mode` and `ServiceConnection`. Done.
- The cost is that templates cannot be used for automation-level "reuse" — but that reuse is always illusory. The real reuse lives in the
  PowerShell functions, where it is testable, composable, and locally executable.

## References

[^1]:
    Richard Bown,
    [Azure DevOps YAML Pipelines: The Land of Confusion](https://richardwbown.com/azure-devops-yaml-pipelines-the-land-of-confusion/) —
    "Azure DevOps has no built-in (pre-commit) validation mechanism for yaml pipelines." Without expansion or validation tooling, nested
    templates force slow feedback loops through pipeline runs.

[^2]:
    Microsoft,
    [Parameters and templateContext](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/template-parameters?view=azure-devops)
    — `templateContext` was introduced to bundle job and environment properties together, reducing the need to declare and forward
    individual parameters through template layers.

## Dora explains:

DORA's research links code clarity to delivery speed and quality. Excessive template abstraction and parameter forwarding slow reviews,
introduce maintenance costs, and obscure pipeline behavior. This ADR's discipline of keeping templates focused on pipeline concerns keeps
the critical path clear.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — flat, reviewable pipeline code reduces cycle time.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — direct step references and shallow nesting keep pipelines
  readable.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — simpler pipelines require less review
  friction.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
