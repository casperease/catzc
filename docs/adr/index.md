---
catzc:
  immutable:
    with_body_sha: fdcdabe91e35
    with_inputs_sha: "791b2b36762f09b2a6d46d37e4ded89f285266a6b645fc02b701229748e78e56"
    repo_status: locked
    path: docs/adr/index.md
    source: pwsh/Catzc.Base.Docs/configs/adrs.yml
    role: index
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
    generator: pwsh/Catzc.Base.Docs/Build-AdrIndex.ps1
---

# ADR index and rule-citation registry

Architecture Decision Records live under `docs/adr/`, grouped by domain — the sections below mirror the domains declared in
`pwsh/Catzc.Base.Docs/configs/adrs.yml`, from which this file is generated. The ADRs define the design principles this codebase must follow.
**Read this index at the start of every session**, then read in full the ADRs that govern the files a task touches, and cite their rules by
code.

## Citing a rule

Every ADR carries a rule registry as its first content section: `## Rules: <code>`, followed by `### Rule <code>-<NAME>` entries (each a
normative summary plus internal links to the prose that justifies it). The grammar is its own ADR, ADR-REPO-ADRCODE.

- A code is a path: `ADR`, then the domain, then the ADR, then the rule, each an upper-case segment joined by `-`, so `ADR-` is the single
  searchable marker for a reference anywhere in the repository (ADR-REPO-ADRCODE-PATHOFSEGMENTS).
- **Cite a rule** by its code, which names it — e.g. `ADR-PWSH-ERROR-THROWNOTWRITEERROR`, `ADR-AUTO-CACHE-READONLYVALUES`,
  `ADR-AZ-NAMING-NEVERTRUNCATE`. A rule is never numbered (ADR-REPO-ADRCODE-NAMEDNOTNUMBERED).
- The code resolves to the heading's anchor, `#rule-` and the code in lower case — e.g.
  `pwsh/error-handling.md#rule-adr-pwsh-error-thrownotwriteerror`.
- A code selects everything below it: `ADR-PWSH` is every ADR of the domain, `ADR-PWSH-ERROR` every rule of the ADR
  (ADR-REPO-ADRCODE-CODEISSELECTOR). There is no group or range spelling; a list of rules is the list of their codes
  (ADR-REPO-ADRCODE-NOSUBSETSPELLING).
- A name is unique under its parent and never reused once retired; the tables below are the authoritative code ↔ ADR mapping.

## Codes

### thesis/

What catzc is for and how it solves it: delivery is slow because its truth is spread across disjoint stores, so catzc collapses them into
one source of truth, the repository, with one change process. The repository is the configuration record and answers queries through the
tooling; inside the trunk everything is at HEAD, and versions exist only at the repository boundary, as pins. It describes the product and
rests on the DORA research, the authoritative source, and the principles state its mechanics, so every other domain cites it (`ADR-THES-*`)
through them.

**Role:** `framing` — **depends on:** `research`.

| Code                | ADR                                                  |
| ------------------- | ---------------------------------------------------- |
| `ADR-THES-ONETRUTH` | [one-source-of-truth](thesis/one-source-of-truth.md) |

### principles/

The design axioms every other domain specialises: everything as code, configure don't program, reduce variability, reduce waste, poka-yoke,
one living version, and the two names of the system, cats and catzc. They specialise the thesis, catzc's product description, and rest on
the DORA research, the authoritative source; no domain later in the order overrides them, and every other domain cites them (`ADR-PRIN-*`)
as the reason for its own decisions.

**Role:** `axioms` — **depends on:** `research`, `thesis`.

| Code                 | ADR                                                          |
| -------------------- | ------------------------------------------------------------ |
| `ADR-PRIN-EAC`       | [everything-as-code](principles/everything-as-code.md)       |
| `ADR-PRIN-CONFIG`    | [configure-not-program](principles/configure-not-program.md) |
| `ADR-PRIN-REDUCEVAR` | [reduce-variability](principles/reduce-variability.md)       |
| `ADR-PRIN-NOWASTE`   | [reduce-waste](principles/reduce-waste.md)                   |
| `ADR-PRIN-POKAYOKE`  | [poka-yoke](principles/poka-yoke.md)                         |
| `ADR-PRIN-ONELIVE`   | [one-living-version](principles/one-living-version.md)       |
| `ADR-PRIN-CATS`      | [cats-and-catzc](principles/cats-and-catzc.md)               |

### process/

How the team works: the Agile Manifesto's values and principles, lean flow as the Toyota Production System maps to software, and one shared
vocabulary of flow terms. Unlike the fixed axioms, the process is itself inspected and improved (`ADR-PROC-KAIZEN`); the design, flow, and
implementation domains put its practices into effect — stopping the line, building quality in, pulling work, and draining queues.

**Role:** `optimisable` — **depends on:** `research`, `principles`.

| Code                       | ADR                                               |
| -------------------------- | ------------------------------------------------- |
| `ADR-PROC-AGILE`           | [agile](process/agile.md)                         |
| `ADR-PROC-VALUES`          | [agile-values](process/agile-values.md)           |
| `ADR-PROC-AGILEPRINCIPLES` | [agile-principles](process/agile-principles.md)   |
| `ADR-PROC-LEANTERMS`       | [process-terms](process/process-terms.md)         |
| `ADR-PROC-LEAN`            | [lean](process/lean.md)                           |
| `ADR-PROC-ANDON`           | [holding-the-line](process/holding-the-line.md)   |
| `ADR-PROC-BUILTIN`         | [build-quality-in](process/build-quality-in.md)   |
| `ADR-PROC-OBSERVEWIP`      | [observe-work](process/observe-work.md)           |
| `ADR-PROC-PULLWORK`        | [pull-work](process/pull-work.md)                 |
| `ADR-PROC-QUEUECOST`       | [queues-cost-money](process/queues-cost-money.md) |
| `ADR-PROC-KAIZEN`          | [inspect-and-adapt](process/inspect-and-adapt.md) |

### design/

How the platform is shaped: tracks as the repository's root concerns, a thin CLI platform over a vendor substrate, safe self-service, the
commit lifecycle and its stable sync point, the audited server remote with pull-request ingress, the visual grammar of the value-chain
diagrams, and the toolset's two run modes (source and build). It builds on research, principles, and process; the flow and implementation
domains realise it.

**Role:** `architecture` — **depends on:** `research`, `principles`, `process`.

| Code                 | ADR                                                              |
| -------------------- | ---------------------------------------------------------------- |
| `ADR-DSGN-TRACK`     | [tracks](design/tracks.md)                                       |
| `ADR-DSGN-THINPLAT`  | [thin-platforms](design/thin-platforms.md)                       |
| `ADR-DSGN-SELFSERV`  | [self-service](design/self-service.md)                           |
| `ADR-DSGN-VISUAL`    | [visual-design](design/visual-design.md)                         |
| `ADR-DSGN-LIFE`      | [commit-lifecycle](design/commit-lifecycle.md)                   |
| `ADR-DSGN-REMOTE`    | [server-remote-integration](design/server-remote-integration.md) |
| `ADR-DSGN-RUNMODE`   | [run-modes](design/run-modes.md)                                 |
| `ADR-DSGN-TRACKTYPE` | [track-types](design/track-types.md)                             |
| `ADR-DSGN-MODTYPE`   | [module-types](design/module-types.md)                           |
| `ADR-DSGN-ASPECT`    | [module-aspects](design/module-aspects.md)                       |

### flow/

The vendor-neutral delivery-flow model: continuous integration as a discipline with a 5–10 minute integration budget, the closed set of
pipeline types (CRON, CI, CD, CDe, DEPLOY, INPUT) keyed together by one immutable tagged artifact, how pipelines invoke automation and
detect their context, and how globsets project into native trigger filters. The pipelines (Azure DevOps) and github domains implement it.

**Role:** `architecture` — **depends on:** `research`, `principles`, `process`, `design`.

| Code                 | ADR                                                                          |
| -------------------- | ---------------------------------------------------------------------------- |
| `ADR-FLOW-CD`        | [cd-discipline-and-promotion-flow](flow/cd-discipline-and-promotion-flow.md) |
| `ADR-FLOW-CD-RUNNER` | [pipeline-runner-pattern](flow/pipeline-runner-pattern.md)                   |
| `ADR-FLOW-CD-DETECT` | [pipeline-detection](flow/pipeline-detection.md)                             |
| `ADR-FLOW-CD-TYPE`   | [pipeline-types](flow/pipeline-types.md)                                     |
| `ADR-FLOW-CD-GLOBS`  | [durable-sha-globs](flow/durable-sha-globs.md)                               |

### automation/

The catzc CLI and module system and the rules for building it: devbox/pipeline parity, one function per file, open/closed growth, fail-fast
assertions, idempotency, caching, path forms, system, module, and internal asset dependencies, the module model, test automation, the
merged, installable build, the five layers of the automation and the importer that decides a session's mix, stated for any execution engine.
Language layers live in `BCL/` (native C# types) and `go/`, `python/`, and `bash/` (black-box test artifacts). It turns the research,
principles, process, and design domains into enforced code; the pwsh domain realises it in PowerShell, and the pipelines, github, and azure
domains build on it.

**Role:** `implementation` — **depends on:** `research`, `principles`, `process`, `design`.

| Code                | ADR                                                                              |
| ------------------- | -------------------------------------------------------------------------------- |
| `ADR-AUTO-PARITY`   | [devbox-pipeline-parity](automation/devbox-pipeline-parity.md)                   |
| `ADR-AUTO-UVPY`     | [uv-python-handler](automation/uv-python-handler.md)                             |
| `ADR-AUTO-PRELOG`   | [log-before-invoke](automation/log-before-invoke.md)                             |
| `ADR-AUTO-RETRY`    | [retry-as-last-resort](automation/retry-as-last-resort.md)                       |
| `ADR-AUTO-EXTEND`   | [open-closed-architecture](automation/open-closed-architecture.md)               |
| `ADR-AUTO-ZERO`     | [zero-ceremony-poka-yoke](automation/zero-ceremony-poka-yoke.md)                 |
| `ADR-AUTO-NOPWD`    | [never-depend-on-pwd](automation/never-depend-on-pwd.md)                         |
| `ADR-AUTO-NONEST`   | [avoid-deep-nesting](automation/avoid-deep-nesting.md)                           |
| `ADR-AUTO-TEST`     | [test-automation](automation/test-automation.md)                                 |
| `ADR-AUTO-XPLAT`    | [cross-platform](automation/cross-platform.md)                                   |
| `ADR-AUTO-ONEJOB`   | [single-responsibility-functions](automation/single-responsibility-functions.md) |
| `ADR-AUTO-CACHE`    | [caching](automation/caching.md)                                                 |
| `ADR-AUTO-MATERIAL` | [materialization](automation/materialization.md)                                 |
| `ADR-AUTO-TRACKED`  | [tracked-files-from-the-index](automation/tracked-files-from-the-index.md)       |
| `ADR-AUTO-DEFAULT`  | [sensible-defaults](automation/sensible-defaults.md)                             |
| `ADR-AUTO-FAILFAST` | [fail-fast-with-asserts](automation/fail-fast-with-asserts.md)                   |
| `ADR-AUTO-IDEM`     | [idempotent-state-functions](automation/idempotent-state-functions.md)           |
| `ADR-AUTO-PKGMGR`   | [use-proper-package-managers](automation/use-proper-package-managers.md)         |
| `ADR-AUTO-ENTERP`   | [effective-in-enterprises](automation/effective-in-enterprises.md)               |
| `ADR-AUTO-DEPS`     | [controlling-systemwide-deps](automation/controlling-systemwide-deps.md)         |
| `ADR-AUTO-REMOVE`   | [tool-removal-lifecycle](automation/tool-removal-lifecycle.md)                   |
| `ADR-AUTO-DEPM`     | [controlling-module-dependencies](automation/controlling-module-dependencies.md) |
| `ADR-AUTO-ENVVAR`   | [environment-variables](automation/environment-variables.md)                     |
| `ADR-AUTO-PATH`     | [path-representation](automation/path-representation.md)                         |
| `ADR-AUTO-GUIDS`    | [managed-guids](automation/managed-guids.md)                                     |
| `ADR-AUTO-BUNDLE`   | [platform-bundle](automation/platform-bundle.md)                                 |
| `ADR-AUTO-OVERLAY`  | [consumer-overlay](automation/consumer-overlay.md)                               |
| `ADR-AUTO-ASSETDEP` | [internal-asset-dependencies](automation/internal-asset-dependencies.md)         |
| `ADR-AUTO-CONSOLE`  | [console-output-matters](automation/console-output-matters.md)                   |
| `ADR-AUTO-SPELL`    | [spell-out-names](automation/spell-out-names.md)                                 |
| `ADR-AUTO-DRYRUN`   | [dry-run](automation/dry-run.md)                                                 |
| `ADR-AUTO-TYPES`    | [native-csharp-types](automation/BCL/native-csharp-types.md)                     |
| `ADR-AUTO-GO`       | [go-test-artifacts](automation/go/go-test-artifacts.md)                          |
| `ADR-AUTO-PY`       | [python-test-artifacts](automation/python/python-test-artifacts.md)              |
| `ADR-AUTO-BASH`     | [bash-test-artifacts](automation/bash/bash-test-artifacts.md)                    |
| `ADR-AUTO-ENGINE`   | [execution-engines](automation/execution-engines.md)                             |
| `ADR-AUTO-MODULE`   | [module-model](automation/module-model.md)                                       |
| `ADR-AUTO-LAYERS`   | [layers](automation/layers.md)                                                   |
| `ADR-AUTO-IMPORTER` | [importer](automation/importer.md)                                               |

### pwsh/

PowerShell 7 as one of catzc's execution engines: how the automation rules are realised in pwsh — module files and manifests, parameter and
error design, streams and console output, caching in script scope, working directory and environment mechanics, cross-platform pwsh, the
analyzer, and Pester. It applies the engine-agnostic `automation/` rules to one engine and never redefines them.

**Role:** `implementation` — **depends on:** `research`, `principles`, `process`, `design`, `automation`.

| Code                | ADR                                                                              |
| ------------------- | -------------------------------------------------------------------------------- |
| `ADR-PWSH-ENGINE`   | [pwsh-engine](pwsh/pwsh-engine.md)                                               |
| `ADR-PWSH-ONEFUNC`  | [one-function-per-file](pwsh/one-function-per-file.md)                           |
| `ADR-PWSH-USEPS`    | [use-ps1-not-psm1](pwsh/use-ps1-not-psm1.md)                                     |
| `ADR-PWSH-MANIFEST` | [dynamic-module-manifests](pwsh/dynamic-module-manifests.md)                     |
| `ADR-PWSH-MODPATH`  | [module-path-hygiene](pwsh/module-path-hygiene.md)                               |
| `ADR-PWSH-VENDOR`   | [vendor-toolset-dependencies](pwsh/vendor-toolset-dependencies.md)               |
| `ADR-PWSH-PREPOST`  | [prepost-extension-modules](pwsh/prepost-extension-modules.md)                   |
| `ADR-PWSH-ERROR`    | [error-handling](pwsh/error-handling.md)                                         |
| `ADR-PWSH-ASSERT`   | [assert-idioms](pwsh/assert-idioms.md)                                           |
| `ADR-PWSH-ANNOUNCE` | [announce-state-changes](pwsh/announce-state-changes.md)                         |
| `ADR-PWSH-NOSEMI`   | [avoid-using-semicolons](pwsh/avoid-using-semicolons.md)                         |
| `ADR-PWSH-FOREACH`  | [prefer-foreach-over-foreach-object](pwsh/prefer-foreach-over-foreach-object.md) |
| `ADR-PWSH-AUTOVAR`  | [automatic-variable-pitfalls](pwsh/automatic-variable-pitfalls.md)               |
| `ADR-PWSH-VERBS`    | [respect-pwsh-verb-rules](pwsh/respect-pwsh-verb-rules.md)                       |
| `ADR-PWSH-DRYRUN`   | [prefer-dryrun-over-shouldprocess](pwsh/prefer-dryrun-over-shouldprocess.md)     |
| `ADR-PWSH-NAMES`    | [identifier-names](pwsh/identifier-names.md)                                     |
| `ADR-PWSH-FORMAT`   | [powershell-formatting](pwsh/powershell-formatting.md)                           |
| `ADR-PWSH-ENV`      | [environment-variable-mechanics](pwsh/environment-variable-mechanics.md)         |
| `ADR-PWSH-PARAM`    | [parameter-design](pwsh/parameter-design.md)                                     |
| `ADR-PWSH-ENUM`     | [bounded-enumeration](pwsh/bounded-enumeration.md)                               |
| `ADR-PWSH-PWD`      | [working-directory-mechanics](pwsh/working-directory-mechanics.md)               |
| `ADR-PWSH-XPLAT`    | [cross-platform-powershell](pwsh/cross-platform-powershell.md)                   |
| `ADR-PWSH-CACHE`    | [script-scope-caching](pwsh/script-scope-caching.md)                             |
| `ADR-PWSH-PESTER`   | [pester-testing](pwsh/pester-testing.md)                                         |
| `ADR-PWSH-TYPES`    | [hosting-csharp-types](pwsh/hosting-csharp-types.md)                             |
| `ADR-PWSH-IDEM`     | [idempotent-state-mechanics](pwsh/idempotent-state-mechanics.md)                 |

### configuration/

How a module's `configs/<name>.yml` files are read, validated, and addressed: one public reader, `Get-Config`, that discovers a config by
its global name, caches it per file, and validates it in its owning module's scope, plus `global.<config>.<key>` addresses that point into
committed config by reference, and config values a tracked Markdown file contributes to a config that opted in. It gives every
implementation domain its single way to read configuration.

**Role:** `implementation` — **depends on:** `research`, `principles`, `automation`.

| Code                  | ADR                                                                             |
| --------------------- | ------------------------------------------------------------------------------- |
| `ADR-CONF-LOADING`    | [module-config-loading](configuration/module-config-loading.md)                 |
| `ADR-CONF-ADDRESSING` | [config-value-addressing](configuration/config-value-addressing.md)             |
| `ADR-CONF-MDCONTRIB`  | [markdown-config-contributions](configuration/markdown-config-contributions.md) |

### pipelines/

The Azure DevOps extensions to the flow model: how ADO REST calls select and prove their credentials, how PowerShell sets pipeline output
variables, how pipelines and template folders are named and placed under `pipelines/`, and when an ADO YAML template is warranted. It binds
the vendor-neutral `flow/` rules to Azure DevOps without redefining them; `github/` is its GitHub counterpart.

**Role:** `implementation` — **depends on:** `research`, `principles`, `process`, `design`, `automation`, `flow`.

| Code                | ADR                                                                         |
| ------------------- | --------------------------------------------------------------------------- |
| `ADR-PIPE-AUTH`     | [dual-authentication](pipelines/dual-authentication.md)                     |
| `ADR-PIPE-VAR`      | [pipeline-variables](pipelines/pipeline-variables.md)                       |
| `ADR-PIPE-NAME`     | [pipeline-naming-and-placement](pipelines/pipeline-naming-and-placement.md) |
| `ADR-PIPE-TEMPLATE` | [custom-template-discipline](pipelines/custom-template-discipline.md)       |

### github/

The GitHub extensions to the flow model: the manually dispatched release workflow that builds the catzc package and publishes it to GitHub
Releases, GitHub Packages, and optionally the PowerShell Gallery. It applies the `flow/` rules to GitHub Actions under `.github/workflows/`
and publishes the bundle the automation domain defines; `pipelines/` is its Azure DevOps counterpart.

**Role:** `implementation` — **depends on:** `research`, `principles`, `process`, `design`, `automation`, `flow`.

| Code             | ADR                                        |
| ---------------- | ------------------------------------------ |
| `ADR-GH-RELEASE` | [github-release](github/github-release.md) |

### azure/

The Azure substrate model catzc deploys onto: the identity data model (`azure.yml` tenants, environments, and subscriptions), the
per-template configuration tree under `infrastructure/templates/`, the customer catalogue (`customer.yml`), the network IP plan
(`network.yml`), the deterministic resource-naming standard, and the landing zones. It applies the principles and design domains to one
vendor, enforced by the `Catzc.Azure*` modules. Beside its own decisions it holds the vendor's recommendations as records: the
Well-Architected Framework pillars in `waf/` and the Cloud Adoption Framework landing-zone design areas in `caf/`, one rule per vendor item,
each citing Microsoft's page and saying what the repository does about it.

**Role:** `implementation` — **depends on:** `research`, `principles`, `design`, `automation`.

| Code                | ADR                                                                           |
| ------------------- | ----------------------------------------------------------------------------- |
| `ADR-AZ-DATAMOD`    | [azure-data-model](azure/azure-data-model.md)                                 |
| `ADR-AZ-NETWORK`    | [azure-network-model](azure/azure-network-model.md)                           |
| `ADR-AZ-NAMING`     | [azure-naming-standard](azure/azure-naming-standard.md)                       |
| `ADR-AZ-CLI`        | [prefer-az-cli](azure/prefer-az-cli.md)                                       |
| `ADR-AZ-SESSION`    | [az-session-verification](azure/az-session-verification.md)                   |
| `ADR-AZ-CUSTOMER`   | [azure-customer-model](azure/azure-customer-model.md)                         |
| `ADR-AZ-LZ`         | [landing-zones](azure/landing-zones.md)                                       |
| `ADR-AZ-WAF-RE`     | [reliability](azure/waf/reliability.md)                                       |
| `ADR-AZ-WAF-SE`     | [security](azure/waf/security.md)                                             |
| `ADR-AZ-WAF-CO`     | [cost-optimization](azure/waf/cost-optimization.md)                           |
| `ADR-AZ-WAF-OE`     | [operational-excellence](azure/waf/operational-excellence.md)                 |
| `ADR-AZ-WAF-PE`     | [performance-efficiency](azure/waf/performance-efficiency.md)                 |
| `ADR-AZ-CAF-PRIN`   | [design-principles](azure/caf/design-principles.md)                           |
| `ADR-AZ-CAF-BILL`   | [billing-and-tenant](azure/caf/billing-and-tenant.md)                         |
| `ADR-AZ-CAF-IAM`    | [identity-and-access](azure/caf/identity-and-access.md)                       |
| `ADR-AZ-CAF-RESORG` | [resource-organization](azure/caf/resource-organization.md)                   |
| `ADR-AZ-CAF-NETTOP` | [network-topology](azure/caf/network-topology.md)                             |
| `ADR-AZ-CAF-NETCON` | [network-connectivity](azure/caf/network-connectivity.md)                     |
| `ADR-AZ-CAF-NETPRV` | [network-private-access](azure/caf/network-private-access.md)                 |
| `ADR-AZ-CAF-SEC`    | [landing-zone-security](azure/caf/landing-zone-security.md)                   |
| `ADR-AZ-CAF-MGMT`   | [management](azure/caf/management.md)                                         |
| `ADR-AZ-CAF-GOV`    | [governance](azure/caf/governance.md)                                         |
| `ADR-AZ-CAF-NAME`   | [naming-and-tagging](azure/caf/naming-and-tagging.md)                         |
| `ADR-AZ-CAF-DEVOPS` | [platform-automation-and-devops](azure/caf/platform-automation-and-devops.md) |

### repository/

How the repository tree is laid out, formatted, and generated: conventional folder names at every level, the single `out/` output directory,
one formatting standard for every file type, contracts at the repository boundary, in both directions, under `contracts/`, READMEs and root
configs generated from one source, fictional documentation examples, the separation of design, test, and live vocabulary, the controlled
vocabulary of defined terms, the reserved meta block in a Markdown file's front matter, repo-wide variants, the sub-agent definitions and
the rules behind each, and sibling repositories read for ideas, never as a reference implementation, and the session-memory protection that
skips a repeated scan over an unchanged globset.

**Role:** `implementation` — **depends on:** `research`, `principles`, `design`, `automation`, `configuration`.

| Code                   | ADR                                                                    |
| ---------------------- | ---------------------------------------------------------------------- |
| `ADR-REPO-FOLDERS`     | [conventional-folders](repository/conventional-folders.md)             |
| `ADR-REPO-OUTDIR`      | [dedicated-output-directory](repository/dedicated-output-directory.md) |
| `ADR-REPO-OUTFMT`      | [output-formats](repository/output-formats.md)                         |
| `ADR-REPO-FORMAT`      | [uniform-formatting](repository/uniform-formatting.md)                 |
| `ADR-REPO-CONTRACT`    | [api-contracts](repository/api-contracts.md)                           |
| `ADR-REPO-CMDCONTRACT` | [command-contracts](repository/command-contracts.md)                   |
| `ADR-REPO-README`      | [generated-readmes](repository/generated-readmes.md)                   |
| `ADR-REPO-ROOTCFG`     | [generated-root-configs](repository/generated-root-configs.md)         |
| `ADR-REPO-EXAMPLE`     | [documentation-examples](repository/documentation-examples.md)         |
| `ADR-REPO-VARIANT`     | [repo-variants](repository/repo-variants.md)                           |
| `ADR-REPO-LANG`        | [domain-language-separation](repository/domain-language-separation.md) |
| `ADR-REPO-VOCAB`       | [controlled-vocabulary](repository/controlled-vocabulary.md)           |
| `ADR-REPO-LINK`        | [markdown-links](repository/markdown-links.md)                         |
| `ADR-REPO-ADRCODE`     | [adr-code-language](repository/adr-code-language.md)                   |
| `ADR-REPO-COMMENTS`    | [comments-in-docs](repository/comments-in-docs.md)                     |
| `ADR-REPO-FILEMETA`    | [file-meta](repository/file-meta.md)                                   |
| `ADR-REPO-CODEMETA`    | [code-file-meta](repository/code-file-meta.md)                         |
| `ADR-REPO-HELP`        | [function-help](repository/function-help.md)                           |
| `ADR-REPO-AGENTS`      | [agent-definitions](repository/agent-definitions.md)                   |
| `ADR-REPO-AI`          | [ai-agent-contract](repository/ai-agent-contract.md)                   |
| `ADR-REPO-INSPIRE`     | [inspiration](repository/inspiration.md)                               |
| `ADR-REPO-PROTGLOB`    | [protected-globs](repository/protected-globs.md)                       |
| `ADR-REPO-PLANS`       | [plans](repository/plans.md)                                           |
| `ADR-REPO-SLIDES`      | [slides-as-markdown](repository/slides-as-markdown.md)                 |

### research/

The repository's core theoretical construct: the DORA research program, held as one ADR-style record per DORA capability, each with its own
`ADR-DORA-<NAME>` rule codes, beside the cross-referenceable research reference in `docs/references/dora/`. It is trusted external
validation — every other domain depends on it and it depends on none; the others cite it through their `dora-explains.md` files and
`ADR-DORA-*` citations.

**Role:** `reference` — **depends on:** none.

| Code                  | ADR                                                                                |
| --------------------- | ---------------------------------------------------------------------------------- |
| `ADR-DORA-AIDATA`     | [ai-accessible-internal-data](research/ai-accessible-internal-data.md)             |
| `ADR-DORA-AISTANCE`   | [clear-and-communicated-ai-stance](research/clear-and-communicated-ai-stance.md)   |
| `ADR-DORA-DATAECO`    | [healthy-data-ecosystems](research/healthy-data-ecosystems.md)                     |
| `ADR-DORA-PLATFORM`   | [platform-engineering](research/platform-engineering.md)                           |
| `ADR-DORA-USERFOCUS`  | [user-centric-focus](research/user-centric-focus.md)                               |
| `ADR-DORA-VCS`        | [version-control](research/version-control.md)                                     |
| `ADR-DORA-SMALLBATCH` | [working-in-small-batches](research/working-in-small-batches.md)                   |
| `ADR-DORA-MAINTAIN`   | [code-maintainability](research/code-maintainability.md)                           |
| `ADR-DORA-CD`         | [continuous-delivery](research/continuous-delivery.md)                             |
| `ADR-DORA-CI`         | [continuous-integration](research/continuous-integration.md)                       |
| `ADR-DORA-DBCHANGE`   | [database-change-management](research/database-change-management.md)               |
| `ADR-DORA-DEPLOY`     | [deployment-automation](research/deployment-automation.md)                         |
| `ADR-DORA-DOCS`       | [documentation-quality](research/documentation-quality.md)                         |
| `ADR-DORA-FLEXINFRA`  | [flexible-infrastructure](research/flexible-infrastructure.md)                     |
| `ADR-DORA-LOOSETEAMS` | [loosely-coupled-teams](research/loosely-coupled-teams.md)                         |
| `ADR-DORA-OBSERV`     | [monitoring-and-observability](research/monitoring-and-observability.md)           |
| `ADR-DORA-SECURITY`   | [pervasive-security](research/pervasive-security.md)                               |
| `ADR-DORA-APPROVAL`   | [streamlining-change-approval](research/streamlining-change-approval.md)           |
| `ADR-DORA-TESTAUTO`   | [test-automation](research/test-automation.md)                                     |
| `ADR-DORA-TESTDATA`   | [test-data-management](research/test-data-management.md)                           |
| `ADR-DORA-TRUNK`      | [trunk-based-development](research/trunk-based-development.md)                     |
| `ADR-DORA-FEEDBACK`   | [customer-feedback](research/customer-feedback.md)                                 |
| `ADR-DORA-MONITOR`    | [monitoring-systems](research/monitoring-systems.md)                               |
| `ADR-DORA-FAILALERT`  | [proactive-failure-notification](research/proactive-failure-notification.md)       |
| `ADR-DORA-WORKVIS`    | [work-visibility-in-value-stream](research/work-visibility-in-value-stream.md)     |
| `ADR-DORA-VISUAL`     | [visual-management](research/visual-management.md)                                 |
| `ADR-DORA-WIP`        | [wip-limits](research/wip-limits.md)                                               |
| `ADR-DORA-TOOLCHOICE` | [teams-empowered-to-choose-tools](research/teams-empowered-to-choose-tools.md)     |
| `ADR-DORA-CULTURE`    | [generative-organizational-culture](research/generative-organizational-culture.md) |
| `ADR-DORA-JOBSAT`     | [job-satisfaction](research/job-satisfaction.md)                                   |
| `ADR-DORA-LEARNING`   | [learning-culture](research/learning-culture.md)                                   |
| `ADR-DORA-EXPERIMENT` | [team-experimentation](research/team-experimentation.md)                           |
| `ADR-DORA-LEADERSHIP` | [transformational-leadership](research/transformational-leadership.md)             |
| `ADR-DORA-WELLBEING`  | [well-being](research/well-being.md)                                               |

## Authoring conventions

These apply when writing or editing any ADR (and largely any doc under `docs/`):

- **Decision and rationale, not config values.** An ADR owns the decision and the _why_; the root config files own the concrete rule values
  (`.editorconfig`, `PSScriptAnalyzerSettings.psd1`, `.markdownlint.yml`, `.gitattributes`, `pwsh/.scriptanalyzer/*.psm1`). Name the
  enforcing file as a pointer, but do not reproduce value tables, pasted `@{ }` rule blocks, or per-rule on/off lists — that duplication
  drifts. Naming a value in order to justify it (for example, "UTF-8, because a BOM breaks `git diff`") is fine; a bare value list with no
  rationale is not.

- **References point one way: code to ADR.** Code, function help, sample headers, and READMEs cite the relevant ADR; an ADR never links back
  to sample or example code, because that couples durable rationale to code churn. The "How this is enforced" sections that _name_ an
  enforcing function are the established exception.

- **Two kinds of link (ADR-REPO-LINK).** A markdown link, in a `.md` file, is relative to its own file
  (`[reduce-variability](../principles/reduce-variability.md)`). A code link, in a comment of any other file, is repository-rooted with the
  citation as its text
  (`[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)`);
  `Format-Links` writes it from the citation, and `Test-Links` checks both kinds.

- **Defined terms live in the glossary.** A defined term means what the one rule that bolds it says
  ([controlled-vocabulary](repository/controlled-vocabulary.md)); [glossary](glossary.md) lists every term with its defining rule, its
  contrasts, and the phrasings to avoid. It is generated from the modules' `configs/glossary.yml` sources — edit a source, never the page.

- **Link granularity is per-context.** Cite a specific rule anchor (`file.md#rule-<code><n>`, e.g.
  `azure-data-model.md#rule-adr-az-datamod-onefileonesubscription`) when the citing sentence, comment, or throw-message invokes one concrete
  rule. Link the ADR document when the context is general — an index list, a "see ADR X for the full rationale" pointer, or a citation that
  invokes the ADR's whole thesis. Over-narrowing a general pointer to one rule is worse than leaving it doc-level.

- **Plain language.** Write in plain English; avoid terse logic or math jargon. Never use "iff" — spell out both directions ("required when
  Y; an error otherwise", or "present exactly when Y"). Prefer "when" / "only when" / "exactly when".

- **Present tense, not a changelog.** An ADR describes the _current_ design as if it had always been that way. It never records what the
  code used to do, what was removed/renamed/migrated, that a decision is recent, or which past incident motivated a rule — that history
  lives in git, not here. Drop change/time markers ("now", "no longer", "previously", "originally", "we used to", "this ADR replaces/moves",
  "still", "today", "already") and war-stories ("we learned this the hard way", "has cost us a red suite"). Argue against a rejected
  alternative in the present ("a global `Set-Location` is unsafe"), not as a journey ("what we tried"); state a rule and its present-tense
  rationale, never the path that led to it.

- **Blank-line padding.** Pad every section: a blank line immediately after each `##`/`###` heading, and a blank line before the next
  heading. This applies to the `## Rules: <code>` registries and the `### Rule <code>:<n>` entries as well.

- **Cite DORA through the local reference.** DORA is the repository's core theoretical construct, and `docs/references/dora/` is its citable
  map: the Core Model (`core-model.md`), the delivery metrics (`metrics.md`), the capability catalogue grouped by the site's own categories
  (`capabilities.md`), the AI Capabilities Model (`ai.md`), and every publication (`publications.md`). Each heading there has a stable
  anchor and carries its dora.dev source URL. Link a capability as `capabilities.md#<dora-slug>`, a metric as `metrics.md#<metric-name>`, a
  publication as `publications.md#<year>-<title>`, and the research program as `index.md` — never a deep link into dora.dev, which lives
  only inside `docs/references/dora/` and in the research ADRs' `## References` footnotes.

- **`dora-explains.md` collects each domain's DORA rationale.** An ADR outside `research/` carries no `## Dora explains` section; instead
  every other domain folder keeps a `dora-explains.md` that consolidates, one entry per ADR, the short present-tense paragraph tying that
  ADR's topic to DORA research and its 2–4 domain-relevant capability links (each
  `[Capability](<relative>/capabilities.md#<dora-slug>) — why it is relevant`, plus a link to the reference's `index.md`). Link only the
  capabilities that genuinely bear on an ADR's domain, never the whole catalogue. DORA grounds the repository's own decisions; an ADR that
  answers a vendor's checklist item by item (`azure/caf/`, `azure/waf/`) is grounded in that vendor's reference (`docs/references/caf/`,
  `docs/references/waf/`) and takes no entry (`adr-checks.yml` `exempt_folders`).

- **The research ADRs carry their own `## Dora explains`.** Each `research/<slug>.md` is the record of one DORA capability, so it is the one
  place an ADR ends with a `## Dora explains` section: the capability's site category and Core Model position, the publications its evidence
  comes from, and its related capabilities, all as links into `docs/references/dora/`. `research/` therefore has no `dora-explains.md`.
