---
catzc:
  immutable:
    with_body_sha: bade2cce318a
    warning: "Do Not Edit, this file is generated"
---

# DRS index and rule-citation registry

The Decision Records System (DRS) holds every decision record under `docs/drs/`, each of one registered record kind, grouped by domain — the
sections below mirror the domains declared in `pwsh/Base.Drs/configs/drs.yml`, from which this file is generated. The ADRs define the design
principles this codebase must follow. **Read this index at the start of every session**, then read in full the ADRs that govern the files a
task touches, and cite their rules by code.

## Citing a rule

Every ADR carries a rule registry as its first content section: `## Rules: <code>`, followed by `### Rule <code>-<NAME>` entries (each a
normative summary plus internal links to the prose that justifies it). The grammar is its own ADR, ADR-REPO-DRSCODE.

- A code is a path: the record kind, then the domain where the kind is shared, then the record, then the rule, each an upper-case segment
  joined by `-`; the registered kinds (`ADR`, `TDR`, `PDR`, `WDR`, `DDR`, `FDR`, `EDR`) are the searchable markers for a reference anywhere
  in the repository (ADR-REPO-DRSCODE-PATHOFSEGMENTS). A domain that owns its kind drops its domain segment; the implementation domains
  share `ADR` and keep theirs (ADR-REPO-DRSCODE-DOMAINSEGMENT).
- **Cite a rule** by its code, which names it — e.g. `ADR-PWSH-ERROR-THROWNOTWRITEERROR`, `ADR-AUTO-CACHE-READONLYVALUES`,
  `ADR-AZ-NAMING-NEVERTRUNCATE`. A rule is never numbered (ADR-REPO-DRSCODE-NAMEDNOTNUMBERED).
- The code resolves to the heading's anchor, `#rule-` and the code in lower case — e.g.
  `automation/pwsh/error-handling.md#rule-adr-pwsh-error-thrownotwriteerror`.
- A code selects everything below it: a kind is every record of that kind, `ADR-PWSH` every ADR of the domain, `ADR-PWSH-ERROR` every rule
  of the ADR (ADR-REPO-DRSCODE-CODEISSELECTOR). There is no group or range spelling; a list of rules is the list of their codes
  (ADR-REPO-DRSCODE-NOSUBSETSPELLING). The index lists records, never rule codes: `Test-DrsRegistry` reads a record's rules from the record
  itself.
- A rule name is unique in the repository and never reused once retired; the tables below are the authoritative code ↔ ADR mapping.

## Codes

### thesis/

What catzc is for and how it solves it: delivery is slow because its truth is spread across disjoint stores, so catzc collapses them into
one source of truth, the repository, with one change process. The repository is the configuration record and answers queries through the
tooling; inside the trunk everything is at HEAD, and versions exist only at the repository boundary, as pins. Outside the responsibility
domain a repository holds, the truth stores are fact sources and state machines, read and reported to at junctions and synchronised into
actionable facts. Any code, unordered fragments included, has an eac normal form: verifiable within the sensible defaults, the bundle, and
the local configs, and uncontested by the repository's formatters, tests, and asserts. It describes the product and rests on the DORA
research, the authoritative source, and the principles state its mechanics, so every other domain cites it (`TDR-*`) through them.

**Role:** `framing` — **depends on:** `external`.

| Code             | ADR                                                  |
| ---------------- | ---------------------------------------------------- |
| `TDR-ONETRUTH`   | [one-source-of-truth](thesis/one-source-of-truth.md) |
| `TDR-STORES`     | [truth-stores](thesis/truth-stores.md)               |
| `TDR-NORMALFORM` | [eac-normal-form](thesis/eac-normal-form.md)         |
| `TDR-CLOSEDLOOP` | [closed-loop](thesis/closed-loop.md)                 |

### principles/

The design axioms every other domain specialises: everything as code, configure don't program, reduce variability, reduce waste, poka-yoke,
one living version, and the two names of the system, cats and catzc. They specialise the thesis, catzc's product description, and rest on
the DORA research, the authoritative source; no domain later in the order overrides them, and every other domain cites them (`PDR-*`) as the
reason for its own decisions.

**Role:** `axioms` — **depends on:** `external`, `thesis`.

| Code            | ADR                                                          |
| --------------- | ------------------------------------------------------------ |
| `PDR-EAC`       | [everything-as-code](principles/everything-as-code.md)       |
| `PDR-CONFIG`    | [configure-not-program](principles/configure-not-program.md) |
| `PDR-REDUCEVAR` | [reduce-variability](principles/reduce-variability.md)       |
| `PDR-NOWASTE`   | [reduce-waste](principles/reduce-waste.md)                   |
| `PDR-POKAYOKE`  | [poka-yoke](principles/poka-yoke.md)                         |
| `PDR-ONELIVE`   | [one-living-version](principles/one-living-version.md)       |
| `PDR-CATS`      | [cats-and-catzc](principles/cats-and-catzc.md)               |

### process/

How the team works: lean flow as the Toyota Production System maps to software, as the external Agile and lean records state it, and one
shared vocabulary of flow terms. Unlike the fixed axioms, the process is itself inspected and improved (`WDR-KAIZEN`); the design, flow, and
implementation domains put its practices into effect — stopping the line, building quality in, pulling work, and draining queues.

**Role:** `optimisable` — **depends on:** `external`, `principles`.

| Code             | ADR                                               |
| ---------------- | ------------------------------------------------- |
| `WDR-LEANTERMS`  | [process-terms](process/process-terms.md)         |
| `WDR-ANDON`      | [holding-the-line](process/holding-the-line.md)   |
| `WDR-BUILTIN`    | [build-quality-in](process/build-quality-in.md)   |
| `WDR-OBSERVEWIP` | [observe-work](process/observe-work.md)           |
| `WDR-PULLWORK`   | [pull-work](process/pull-work.md)                 |
| `WDR-QUEUECOST`  | [queues-cost-money](process/queues-cost-money.md) |
| `WDR-KAIZEN`     | [inspect-and-adapt](process/inspect-and-adapt.md) |

### design/

How the platform is shaped: tracks as the repository's root concerns, a thin CLI platform over a vendor substrate, safe self-service, the
audited server remote with pull-request ingress, the visual grammar of the value-chain diagrams, and the toolset's two run modes (source and
build). It builds on the external records, principles, and process; the flow and implementation domains realise it.

**Role:** `architecture` — **depends on:** `external`, `principles`, `process`.

| Code            | ADR                                                              |
| --------------- | ---------------------------------------------------------------- |
| `DDR-TRACK`     | [tracks](design/tracks.md)                                       |
| `DDR-THINPLAT`  | [thin-platforms](design/thin-platforms.md)                       |
| `DDR-SELFSERV`  | [self-service](design/self-service.md)                           |
| `DDR-VISUAL`    | [visual-design](design/visual-design.md)                         |
| `DDR-REMOTE`    | [server-remote-integration](design/server-remote-integration.md) |
| `DDR-RUNMODE`   | [run-modes](design/run-modes.md)                                 |
| `DDR-TRACKTYPE` | [track-types](design/track-types.md)                             |
| `DDR-VENDOR`    | [vendoring](design/vendoring.md)                                 |
| `DDR-MODTYPE`   | [module-types](design/module-types.md)                           |
| `DDR-ASPECT`    | [module-aspects](design/module-aspects.md)                       |
| `DDR-FILTER`    | [repository-filters](design/repository-filters.md)               |

### flow/

The vendor-neutral delivery-flow model: what a CI/CD pipeline is, continuous integration as a discipline with a 5–10 minute integration
budget, the closed set of pipeline types (CRON, CI, CD, CDe, DEPLOY, INPUT) keyed together by one immutable tagged artifact, how pipelines
invoke automation and detect their context, how globsets project into native trigger filters, and the commit lifecycle a promoted commit
climbs, with its stable sync point, and the git paths a topic takes to and from the server's main. The ado (Azure DevOps) and github domains
implement it.

**Role:** `architecture` — **depends on:** `external`, `principles`, `process`, `design`.

| Code           | ADR                                                                          |
| -------------- | ---------------------------------------------------------------------------- |
| `FDR-CD`       | [cd-discipline-and-promotion-flow](flow/cd-discipline-and-promotion-flow.md) |
| `FDR-RUNNER`   | [pipeline-runner-pattern](flow/pipeline-runner-pattern.md)                   |
| `FDR-DETECT`   | [pipeline-detection](flow/pipeline-detection.md)                             |
| `FDR-TYPE`     | [pipeline-types](flow/pipeline-types.md)                                     |
| `FDR-GLOBS`    | [durable-sha-globs](flow/durable-sha-globs.md)                               |
| `FDR-PIPELINE` | [pipeline-concept](flow/pipeline-concept.md)                                 |
| `FDR-LIFE`     | [commit-lifecycle](flow/commit-lifecycle.md)                                 |
| `FDR-QUEUE`    | [manual-queues](flow/manual-queues.md)                                       |
| `FDR-GIT`      | [git-topic-flow](flow/git-topic-flow.md)                                     |

### automation/

The catzc CLI and module system and the rules for building it: devbox/pipeline parity, one function per file, open/closed growth, fail-fast
assertions, idempotency, caching, path forms, system, module, and internal asset dependencies, the module model, test automation, the
merged, installable build, the five layers of the automation and the importer that decides a session's mix, stated for any execution engine.
Language layers live in `go/`, `python/`, and `bash/` (black-box test artifacts); the BCL language of the native C# types is the bcl domain.
It turns the external, principles, process, and design domains into enforced code; the pwsh domain realises it in PowerShell, and the ado,
github, and azure domains build on it.

**Role:** `implementation` — **depends on:** `external`, `principles`, `process`, `design`.

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
| `ADR-AUTO-IDIOM`    | [idiomatic-names](automation/idiomatic-names.md)                                 |
| `ADR-AUTO-DRYRUN`   | [dry-run](automation/dry-run.md)                                                 |
| `ADR-AUTO-LIMIT`    | [file-limits](automation/file-limits.md)                                         |
| `ADR-AUTO-GO`       | [go-test-artifacts](automation/go/go-test-artifacts.md)                          |
| `ADR-AUTO-PY`       | [python-test-artifacts](automation/python/python-test-artifacts.md)              |
| `ADR-AUTO-BASH`     | [bash-test-artifacts](automation/bash/bash-test-artifacts.md)                    |
| `ADR-AUTO-JS`       | [javascript-track](automation/javascript/javascript-track.md)                    |
| `ADR-AUTO-ENGINE`   | [execution-engines](automation/execution-engines.md)                             |
| `ADR-AUTO-MODULE`   | [module-model](automation/module-model.md)                                       |
| `ADR-AUTO-LAYERS`   | [layers](automation/layers.md)                                                   |
| `ADR-AUTO-IMPORTER` | [importer](automation/importer.md)                                               |
| `ADR-AUTO-ACCOSTED` | [accosted-language](automation/accosted-language.md)                             |
| `ADR-AUTO-NET`      | [network-calls](automation/network-calls.md)                                     |

### automation/BCL/

BCL as a language of catzc's own: C# against the .NET Base Class Library, a subset of .NET, written in the `types/*.cs` sources — one type
per file, a namespace per module, one combined assembly, the Base Class Library as the whole reference set with each host binding a
configured exception, and the one build pair of its solution and projects. pwsh is its host, not its owner: how pwsh compiles and carries
the types is the pwsh domain's.

**Role:** `implementation` — **depends on:** `external`, `principles`, `process`, `design`, `automation`.

| Code            | ADR                                                          |
| --------------- | ------------------------------------------------------------ |
| `ADR-BCL-TYPES` | [native-csharp-types](automation/BCL/native-csharp-types.md) |

### automation/pwsh/

PowerShell 7 as one of catzc's execution engines: how the automation rules are realised in pwsh — module files and manifests, parameter and
error design, streams and console output, caching in script scope, working directory and environment mechanics, cross-platform pwsh, the
analyzer, and Pester. It applies the engine-agnostic `automation/` rules to one engine and never redefines them.

**Role:** `implementation` — **depends on:** `external`, `principles`, `process`, `design`, `automation`, `bcl`.

| Code                | ADR                                                                                         |
| ------------------- | ------------------------------------------------------------------------------------------- |
| `ADR-PWSH-ENGINE`   | [pwsh-engine](automation/pwsh/pwsh-engine.md)                                               |
| `ADR-PWSH-ONEFUNC`  | [one-function-per-file](automation/pwsh/one-function-per-file.md)                           |
| `ADR-PWSH-USEPS`    | [use-ps1-not-psm1](automation/pwsh/use-ps1-not-psm1.md)                                     |
| `ADR-PWSH-MANIFEST` | [dynamic-module-manifests](automation/pwsh/dynamic-module-manifests.md)                     |
| `ADR-PWSH-MODPATH`  | [module-path-hygiene](automation/pwsh/module-path-hygiene.md)                               |
| `ADR-PWSH-VENDOR`   | [vendor-toolset-dependencies](automation/pwsh/vendor-toolset-dependencies.md)               |
| `ADR-PWSH-PREPOST`  | [prepost-extension-modules](automation/pwsh/prepost-extension-modules.md)                   |
| `ADR-PWSH-ERROR`    | [error-handling](automation/pwsh/error-handling.md)                                         |
| `ADR-PWSH-ASSERT`   | [assert-idioms](automation/pwsh/assert-idioms.md)                                           |
| `ADR-PWSH-ANNOUNCE` | [announce-state-changes](automation/pwsh/announce-state-changes.md)                         |
| `ADR-PWSH-NOSEMI`   | [avoid-using-semicolons](automation/pwsh/avoid-using-semicolons.md)                         |
| `ADR-PWSH-FOREACH`  | [prefer-foreach-over-foreach-object](automation/pwsh/prefer-foreach-over-foreach-object.md) |
| `ADR-PWSH-AUTOVAR`  | [automatic-variable-pitfalls](automation/pwsh/automatic-variable-pitfalls.md)               |
| `ADR-PWSH-VERBS`    | [respect-pwsh-verb-rules](automation/pwsh/respect-pwsh-verb-rules.md)                       |
| `ADR-PWSH-DRYRUN`   | [prefer-dryrun-over-shouldprocess](automation/pwsh/prefer-dryrun-over-shouldprocess.md)     |
| `ADR-PWSH-NAMES`    | [identifier-names](automation/pwsh/identifier-names.md)                                     |
| `ADR-PWSH-FORMAT`   | [powershell-formatting](automation/pwsh/powershell-formatting.md)                           |
| `ADR-PWSH-ENV`      | [environment-variable-mechanics](automation/pwsh/environment-variable-mechanics.md)         |
| `ADR-PWSH-PARAM`    | [parameter-design](automation/pwsh/parameter-design.md)                                     |
| `ADR-PWSH-ENUM`     | [bounded-enumeration](automation/pwsh/bounded-enumeration.md)                               |
| `ADR-PWSH-PWD`      | [working-directory-mechanics](automation/pwsh/working-directory-mechanics.md)               |
| `ADR-PWSH-XPLAT`    | [cross-platform-powershell](automation/pwsh/cross-platform-powershell.md)                   |
| `ADR-PWSH-CACHE`    | [script-scope-caching](automation/pwsh/script-scope-caching.md)                             |
| `ADR-PWSH-PESTER`   | [pester-testing](automation/pwsh/pester-testing.md)                                         |
| `ADR-PWSH-TYPES`    | [hosting-csharp-types](automation/pwsh/hosting-csharp-types.md)                             |
| `ADR-PWSH-IDEM`     | [idempotent-state-mechanics](automation/pwsh/idempotent-state-mechanics.md)                 |

### configuration/

How a module's `configs/<name>.yml` files are read, validated, and addressed: one public reader, `Get-Config`, that discovers a config by
its global name, caches it per file, and validates it in its owning module's scope, plus `global.<config>.<key>` addresses that point into
committed config by reference, and config values a tracked Markdown file contributes to a config that opted in. It gives every
implementation domain its single way to read configuration.

**Role:** `implementation` — **depends on:** `external`, `principles`, `automation`, `bcl`.

| Code                  | ADR                                                                             |
| --------------------- | ------------------------------------------------------------------------------- |
| `ADR-CONF-LOADING`    | [module-config-loading](configuration/module-config-loading.md)                 |
| `ADR-CONF-ADDRESSING` | [config-value-addressing](configuration/config-value-addressing.md)             |
| `ADR-CONF-MDCONTRIB`  | [markdown-config-contributions](configuration/markdown-config-contributions.md) |

### ado/

The Azure DevOps extensions to the flow model: how ADO REST calls select and prove their credentials, how PowerShell sets ado pipeline
output variables, how ado pipelines and template folders are named and placed under `.ado/pipelines/`, and when an ADO YAML template is
warranted. It binds the vendor-neutral `flow/` rules to Azure DevOps without redefining them; `github/` is its GitHub counterpart.

**Role:** `implementation` — **depends on:** `external`, `principles`, `process`, `design`, `automation`, `flow`.

| Code               | ADR                                                                   |
| ------------------ | --------------------------------------------------------------------- |
| `ADR-ADO-AUTH`     | [dual-authentication](ado/dual-authentication.md)                     |
| `ADR-ADO-VAR`      | [pipeline-variables](ado/pipeline-variables.md)                       |
| `ADR-ADO-NAME`     | [pipeline-naming-and-placement](ado/pipeline-naming-and-placement.md) |
| `ADR-ADO-TEMPLATE` | [custom-template-discipline](ado/custom-template-discipline.md)       |

### github/

The GitHub extensions to the flow model: the manually dispatched release workflow that builds the catzc package and publishes it to GitHub
Releases, GitHub Packages, and optionally the PowerShell Gallery. It applies the `flow/` rules to GitHub Actions under `.github/workflows/`
and publishes the bundle the automation domain defines; `ado/` is its Azure DevOps counterpart.

**Role:** `implementation` — **depends on:** `external`, `principles`, `process`, `design`, `automation`, `flow`.

| Code             | ADR                                        |
| ---------------- | ------------------------------------------ |
| `ADR-GH-RELEASE` | [github-release](github/github-release.md) |

### azure/

The Azure substrate model catzc deploys onto: the identity data model (`azure.yml` tenants, environments, and subscriptions), the
per-template configuration tree under `infrastructure/templates/`, the customer catalogue (`customer.yml`), the network IP plan
(`network.yml`), the deterministic resource-naming standard, and the landing zones. It applies the principles and design domains to one
vendor, enforced by the `Catzc.Azure*` modules. The vendor's own recommendations, the Well-Architected Framework pillars and the Cloud
Adoption Framework landing-zone design areas, are external records; the decisions here answer them.

**Role:** `implementation` — **depends on:** `external`, `principles`, `design`, `automation`, `flow`, `ado`.

| Code              | ADR                                                         |
| ----------------- | ----------------------------------------------------------- |
| `ADR-AZ-DATAMOD`  | [azure-data-model](azure/azure-data-model.md)               |
| `ADR-AZ-NETWORK`  | [azure-network-model](azure/azure-network-model.md)         |
| `ADR-AZ-NAMING`   | [azure-naming-standard](azure/azure-naming-standard.md)     |
| `ADR-AZ-CLI`      | [prefer-az-cli](azure/prefer-az-cli.md)                     |
| `ADR-AZ-SESSION`  | [az-session-verification](azure/az-session-verification.md) |
| `ADR-AZ-CUSTOMER` | [azure-customer-model](azure/azure-customer-model.md)       |
| `ADR-AZ-LZ`       | [landing-zones](azure/landing-zones.md)                     |
| `ADR-AZ-IACKIND`  | [infrastructure-kinds](azure/infrastructure-kinds.md)       |

### repository/

How the repository tree is laid out, formatted, and generated: conventional folder names at every level, the single `out/` output directory,
one formatting standard for every file type, contracts at the repository boundary, in both directions, under `contracts/`, READMEs and root
configs generated from one source, fictional documentation examples, the separation of design, test, and live vocabulary, the controlled
vocabulary of defined terms, the directions a link may point, the reserved meta block in a Markdown file's front matter, repo-wide variants,
the sub-agent definitions and the rules behind each, and sibling repositories read for ideas, never as a reference implementation, and the
session-memory protection that skips a repeated scan over an unchanged globset.

**Role:** `implementation` — **depends on:** `external`, `principles`, `design`, `automation`, `configuration`, `bcl`.

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
| `ADR-REPO-LINKS`       | [links-in-repository](repository/links-in-repository.md)               |
| `ADR-REPO-DRSCODE`     | [drs-code-language](repository/drs-code-language.md)                   |
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
| `ADR-REPO-REPOKIND`    | [repository-kinds](repository/repository-kinds.md)                     |

### external/

The outside guidance catzc rests on or answers item by item, one record per source item, kept apart from catzc's own decisions: the DORA
research program in `dora/`, the Microsoft Well-Architected Framework in `azure/waf/` and Cloud Adoption Framework in `azure/caf/`, the
Agile Manifesto in `agile/`, lean theory in `lean/`, and Pester in `pester/`. A code keeps its source path under the EDR kind
(`EDR-DORA-CI`, `EDR-AZ-CAF-GOV`), and an item keeps the source's own id (a Well-Architected item `RE01`, a Cloud Adoption Framework item
`R01`). A rule states how catzc reads the item, with a `Source:` line that names it, a Microsoft page as `learn <path>` under the one base
`https://learn.microsoft.com/en-us`; the ADR or PDR that cites the rule holds catzc's own decision. Every other domain depends on this one
and it depends on none; the others cite the DORA records through their `dora-explains.md` files and `EDR-DORA-*` citations.

**Role:** `reference` — **depends on:** none.

| Code                  | ADR                                                                                     |
| --------------------- | --------------------------------------------------------------------------------------- |
| `EDR-DORA-AIDATA`     | [ai-accessible-internal-data](external/dora/ai-accessible-internal-data.md)             |
| `EDR-DORA-AISTANCE`   | [clear-and-communicated-ai-stance](external/dora/clear-and-communicated-ai-stance.md)   |
| `EDR-DORA-DATAECO`    | [healthy-data-ecosystems](external/dora/healthy-data-ecosystems.md)                     |
| `EDR-DORA-PLATFORM`   | [platform-engineering](external/dora/platform-engineering.md)                           |
| `EDR-DORA-USERFOCUS`  | [user-centric-focus](external/dora/user-centric-focus.md)                               |
| `EDR-DORA-VCS`        | [version-control](external/dora/version-control.md)                                     |
| `EDR-DORA-SMALLBATCH` | [working-in-small-batches](external/dora/working-in-small-batches.md)                   |
| `EDR-DORA-MAINTAIN`   | [code-maintainability](external/dora/code-maintainability.md)                           |
| `EDR-DORA-CD`         | [continuous-delivery](external/dora/continuous-delivery.md)                             |
| `EDR-DORA-CI`         | [continuous-integration](external/dora/continuous-integration.md)                       |
| `EDR-DORA-DBCHANGE`   | [database-change-management](external/dora/database-change-management.md)               |
| `EDR-DORA-DEPLOY`     | [deployment-automation](external/dora/deployment-automation.md)                         |
| `EDR-DORA-DOCS`       | [documentation-quality](external/dora/documentation-quality.md)                         |
| `EDR-DORA-FLEXINFRA`  | [flexible-infrastructure](external/dora/flexible-infrastructure.md)                     |
| `EDR-DORA-LOOSETEAMS` | [loosely-coupled-teams](external/dora/loosely-coupled-teams.md)                         |
| `EDR-DORA-OBSERV`     | [monitoring-and-observability](external/dora/monitoring-and-observability.md)           |
| `EDR-DORA-SECURITY`   | [pervasive-security](external/dora/pervasive-security.md)                               |
| `EDR-DORA-APPROVAL`   | [streamlining-change-approval](external/dora/streamlining-change-approval.md)           |
| `EDR-DORA-TESTAUTO`   | [test-automation](external/dora/test-automation.md)                                     |
| `EDR-DORA-TESTDATA`   | [test-data-management](external/dora/test-data-management.md)                           |
| `EDR-DORA-TRUNK`      | [trunk-based-development](external/dora/trunk-based-development.md)                     |
| `EDR-DORA-FEEDBACK`   | [customer-feedback](external/dora/customer-feedback.md)                                 |
| `EDR-DORA-MONITOR`    | [monitoring-systems](external/dora/monitoring-systems.md)                               |
| `EDR-DORA-FAILALERT`  | [proactive-failure-notification](external/dora/proactive-failure-notification.md)       |
| `EDR-DORA-WORKVIS`    | [work-visibility-in-value-stream](external/dora/work-visibility-in-value-stream.md)     |
| `EDR-DORA-VISUAL`     | [visual-management](external/dora/visual-management.md)                                 |
| `EDR-DORA-WIP`        | [wip-limits](external/dora/wip-limits.md)                                               |
| `EDR-DORA-TOOLCHOICE` | [teams-empowered-to-choose-tools](external/dora/teams-empowered-to-choose-tools.md)     |
| `EDR-DORA-CULTURE`    | [generative-organizational-culture](external/dora/generative-organizational-culture.md) |
| `EDR-DORA-JOBSAT`     | [job-satisfaction](external/dora/job-satisfaction.md)                                   |
| `EDR-DORA-LEARNING`   | [learning-culture](external/dora/learning-culture.md)                                   |
| `EDR-DORA-EXPERIMENT` | [team-experimentation](external/dora/team-experimentation.md)                           |
| `EDR-DORA-LEADERSHIP` | [transformational-leadership](external/dora/transformational-leadership.md)             |
| `EDR-DORA-WELLBEING`  | [well-being](external/dora/well-being.md)                                               |
| `EDR-AZ-WAF-RE`       | [reliability](external/azure/waf/reliability.md)                                        |
| `EDR-AZ-WAF-SE`       | [security](external/azure/waf/security.md)                                              |
| `EDR-AZ-WAF-CO`       | [cost-optimization](external/azure/waf/cost-optimization.md)                            |
| `EDR-AZ-WAF-OE`       | [operational-excellence](external/azure/waf/operational-excellence.md)                  |
| `EDR-AZ-WAF-PE`       | [performance-efficiency](external/azure/waf/performance-efficiency.md)                  |
| `EDR-AZ-CAF-PRIN`     | [design-principles](external/azure/caf/design-principles.md)                            |
| `EDR-AZ-CAF-BILL`     | [billing-and-tenant](external/azure/caf/billing-and-tenant.md)                          |
| `EDR-AZ-CAF-IAM`      | [identity-and-access](external/azure/caf/identity-and-access.md)                        |
| `EDR-AZ-CAF-RESORG`   | [resource-organization](external/azure/caf/resource-organization.md)                    |
| `EDR-AZ-CAF-NETTOP`   | [network-topology](external/azure/caf/network-topology.md)                              |
| `EDR-AZ-CAF-NETCON`   | [network-connectivity](external/azure/caf/network-connectivity.md)                      |
| `EDR-AZ-CAF-NETPRV`   | [network-private-access](external/azure/caf/network-private-access.md)                  |
| `EDR-AZ-CAF-SEC`      | [landing-zone-security](external/azure/caf/landing-zone-security.md)                    |
| `EDR-AZ-CAF-MGMT`     | [management](external/azure/caf/management.md)                                          |
| `EDR-AZ-CAF-GOV`      | [governance](external/azure/caf/governance.md)                                          |
| `EDR-AZ-CAF-NAME`     | [naming-and-tagging](external/azure/caf/naming-and-tagging.md)                          |
| `EDR-AZ-CAF-DEVOPS`   | [platform-automation-and-devops](external/azure/caf/platform-automation-and-devops.md)  |
| `EDR-AGILE`           | [agile](external/agile/agile.md)                                                        |
| `EDR-VALUES`          | [agile-values](external/agile/agile-values.md)                                          |
| `EDR-AGILEPRINCIPLES` | [agile-principles](external/agile/agile-principles.md)                                  |
| `EDR-LEAN`            | [lean](external/lean/lean.md)                                                           |
| `EDR-PWSH-PESTER`     | [pester-framework](external/pester/pester-framework.md)                                 |

## Authoring conventions

These apply when writing or editing any ADR (and largely any doc under `docs/`):

- **Decision and rationale, not config values.** An ADR owns the decision and the _why_; the root config files own the concrete rule values
  (`.editorconfig`, `PSScriptAnalyzerSettings.psd1`, `.markdownlint.yml`, `.gitattributes`, `pwsh/.scriptanalyzer/*.psm1`). Name the
  enforcing file as a pointer, but do not reproduce value tables, pasted `@{ }` rule blocks, or per-rule on/off lists — that duplication
  drifts. Naming a value in order to justify it (for example, "UTF-8, because a BOM breaks `git diff`") is fine; a bare value list with no
  rationale is not.

- **`automation/` is engine-neutral; a language's ADRs sit in `automation/<language>/`.** An ADR in `automation/` states its rules for any
  engine, and the language's spellings and samples live in the twin under `automation/<language>/` (`Test-DrsEngineNeutrality` judges the
  rules). A language with its own code prefix is its own domain, and its `folder` in `drs.yml` points into `automation/`, so `ADR-PWSH-*`
  keeps its codes while its pages sit in `automation/pwsh/`; a code names the rule, never the path.

- **References point one way: code to ADR.** Code, function help, sample headers, and READMEs cite the relevant ADR; an ADR never links back
  to sample or example code, because that couples durable rationale to code churn. The "How this is enforced" sections that _name_ an
  enforcing function are the established exception.

- **Two kinds of link (ADR-REPO-LINK).** A markdown link, in a `.md` file, is relative to its own file
  (`[reduce-variability](../principles/reduce-variability.md)`). A code link, in a comment of any other file, is repository-rooted with the
  citation as its text
  (`[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)`);
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
  heading. This applies to the `## Rules: <code>` registries and the `### Rule <code>-<NAME>` entries as well.

- **Cite DORA through the local reference.** DORA is the repository's core theoretical construct, and `docs/references/dora/` is its citable
  map: the Core Model (`core-model.md`), the delivery metrics (`metrics.md`), the capability catalogue grouped by the site's own categories
  (`capabilities.md`), the AI Capabilities Model (`ai.md`), and every publication (`publications.md`). Each heading there has a stable
  anchor and carries its dora.dev source URL. Link a capability as `capabilities.md#<dora-slug>`, a metric as `metrics.md#<metric-name>`, a
  publication as `publications.md#<year>-<title>`, and the research program as `index.md` — never a deep link into dora.dev, which lives
  only inside `docs/references/dora/` and in the DORA records' `## References` footnotes.

- **`dora-explains.md` collects each domain's DORA rationale.** An ADR outside `external/` carries no `## Dora explains` section; instead
  every other domain folder keeps a `dora-explains.md` that consolidates, one entry per ADR, the short present-tense paragraph tying that
  ADR's topic to DORA research and its 2–4 domain-relevant capability links (each
  `[Capability](<relative>/capabilities.md#<dora-slug>) — why it is relevant`, plus a link to the reference's `index.md`). Link only the
  capabilities that genuinely bear on an ADR's domain, never the whole catalogue. DORA grounds the repository's own decisions; a record in
  `external/` is grounded in its own source (a vendor record in `docs/references/caf/` or `docs/references/waf/`) and takes no entry
  (`drs-checks.yml` `exempt`).

- **The DORA records carry their own `## Dora explains`.** Each `external/dora/<slug>.md` is the record of one DORA capability, so it is the
  one place an ADR ends with a `## Dora explains` section: the capability's site category and Core Model position, the publications its
  evidence comes from, and its related capabilities, all as links into `docs/references/dora/`. `external/` therefore has no
  `dora-explains.md`.
