# ADR index and rule-citation registry

Architecture Decision Records live under `docs/adr/`, grouped by domain — the sections below mirror the domains declared in
`automation/Catzc.Base.Docs/configs/adrs.yml`, from which this file is generated. The ADRs define the design principles this codebase must
follow. **Read this index at the start of every session**, then read in full the ADRs that govern the files a task touches, and cite their
rules by code.

## Citing a rule

Every ADR carries a numbered rule registry as its first content section: `## Rules: <code>`, followed by `### Rule <code>:<n>` entries (each
a normative summary plus internal links to the prose that justifies it).

- Every `<code>` has the form `ADR-<NAME>` — a literal `ADR-` prefix plus one or more uppercase segments — so `ADR-` is the single
  searchable marker for a rule reference anywhere in the repository.
- **Cite a rule** as `<code>#<n>` — e.g. `ADR-AUTO-ERROR#3`, `ADR-AUTO-CACHE#5`, `ADR-AZ-NAMING#7`.
- That resolves to the anchor `#rule-<code><n>` with the code lowercased and the `:` dropped — e.g.
  `automation/powershell/error-handling.md#rule-adr-auto-error3` (so it is `rule-adr-auto-error3`, not `rule-adr-auto-error-3`).
- The `<code>` is unique per ADR; the tables below are the authoritative code ↔ ADR mapping.
- `#` is the only citation spelling — in comments, test tags, configuration, and prose. The `:` form exists only in the rule's own
  `### Rule <code>:<n>` heading (ADR-REPO-LINK#5).

## Codes

### principles/

The design axioms every other domain specialises: everything as code, reduce variability, reduce waste, poka-yoke, and one living version.
They rest only on the DORA research, no domain later in the order overrides them, and every other domain cites them (`ADR-PRIN-*`) as the
reason for its own decisions.

**Role:** `axioms` — **depends on:** `research`.

| Code                 | ADR                                                    |
| -------------------- | ------------------------------------------------------ |
| `ADR-PRIN-EAC`       | [everything-as-code](principles/everything-as-code.md) |
| `ADR-PRIN-REDUCEVAR` | [reduce-variability](principles/reduce-variability.md) |
| `ADR-PRIN-NOWASTE`   | [reduce-waste](principles/reduce-waste.md)             |
| `ADR-PRIN-POKAYOKE`  | [poka-yoke](principles/poka-yoke.md)                   |
| `ADR-PRIN-ONELIVE`   | [one-living-version](principles/one-living-version.md) |

### process/

How the team works: the Agile Manifesto's values and principles, lean flow as the Toyota Production System maps to software, and one shared
vocabulary of flow terms. Unlike the fixed axioms, the process is itself inspected and improved (`ADR-PROC-KAIZEN`); the design, flow, and
implementation domains put its practices into effect — stopping the line, building quality in, pulling work, and draining queues.

**Role:** `optimisable` — **depends on:** `research`, `principles`.

| Code                  | ADR                                               |
| --------------------- | ------------------------------------------------- |
| `ADR-PROC-AGILE`      | [agile](process/agile.md)                         |
| `ADR-PROC-VALUES`     | [agile-values](process/agile-values.md)           |
| `ADR-PRIN-PROCESS`    | [agile-principles](process/agile-principles.md)   |
| `ADR-PROC-LEANTERMS`  | [process-terms](process/process-terms.md)         |
| `ADR-PROC-LEAN`       | [lean](process/lean.md)                           |
| `ADR-PROC-ANDON`      | [holding-the-line](process/holding-the-line.md)   |
| `ADR-PROC-BUILTIN`    | [build-quality-in](process/build-quality-in.md)   |
| `ADR-PROC-OBSERVEWIP` | [observe-work](process/observe-work.md)           |
| `ADR-PROC-PULLWORK`   | [pull-work](process/pull-work.md)                 |
| `ADR-PROC-QUEUECOST`  | [queues-cost-money](process/queues-cost-money.md) |
| `ADR-PROC-KAIZEN`     | [inspect-and-adapt](process/inspect-and-adapt.md) |

### design/

How the platform is shaped: tracks as the repository's root concerns, a thin CLI platform over a vendor substrate, safe self-service, the
commit lifecycle and its stable sync point, the audited server remote with pull-request ingress, the visual grammar of the value-chain
diagrams, and the toolset's two run modes (source and build). It builds on research, principles, and process; the flow and implementation
domains realise it.

**Role:** `architecture` — **depends on:** `research`, `principles`, `process`.

| Code                | ADR                                                              |
| ------------------- | ---------------------------------------------------------------- |
| `ADR-DSGN-TRACK`    | [tracks](design/tracks.md)                                       |
| `ADR-DSGN-THINPLAT` | [thin-platforms](design/thin-platforms.md)                       |
| `ADR-DSGN-SELFSERV` | [self-service](design/self-service.md)                           |
| `ADR-DSGN-VISUAL`   | [visual-design](design/visual-design.md)                         |
| `ADR-DSGN-LIFE`     | [commit-lifecycle](design/commit-lifecycle.md)                   |
| `ADR-DSGN-REMOTE`   | [server-remote-integration](design/server-remote-integration.md) |
| `ADR-DSGN-RUNMODE`  | [run-modes](design/run-modes.md)                                 |
| `ADR-DSGN-ASPECT`   | [module-aspects](design/module-aspects.md)                       |

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
assertions, idempotency, caching, path forms, system, module, and internal asset dependencies, test automation, and the merged, installable
build. Language layers live in `powershell/`, `BCL/` (native C# types), and `go/` (black-box test artifacts), with `python/` reserved. It
turns the research, principles, process, and design domains into enforced code; the pipelines, github, and azure domains build on it.

**Role:** `implementation` — **depends on:** `research`, `principles`, `process`, `design`.

| Code                | ADR                                                                                               |
| ------------------- | ------------------------------------------------------------------------------------------------- |
| `ADR-AUTO-PARITY`   | [devbox-pipeline-parity](automation/devbox-pipeline-parity.md)                                    |
| `ADR-AUTO-UVPY`     | [uv-python-handler](automation/uv-python-handler.md)                                              |
| `ADR-AUTO-PRELOG`   | [log-before-invoke](automation/log-before-invoke.md)                                              |
| `ADR-AUTO-RETRY`    | [retry-as-last-resort](automation/retry-as-last-resort.md)                                        |
| `ADR-AUTO-EXTEND`   | [open-closed-architecture](automation/open-closed-architecture.md)                                |
| `ADR-AUTO-ZERO`     | [zero-ceremony-poka-yoke](automation/zero-ceremony-poka-yoke.md)                                  |
| `ADR-AUTO-NOPWD`    | [never-depend-on-pwd](automation/never-depend-on-pwd.md)                                          |
| `ADR-AUTO-NONEST`   | [avoid-deep-nesting](automation/avoid-deep-nesting.md)                                            |
| `ADR-AUTO-TEST`     | [test-automation](automation/test-automation.md)                                                  |
| `ADR-AUTO-XPLAT`    | [cross-platform](automation/cross-platform.md)                                                    |
| `ADR-AUTO-ONEJOB`   | [single-responsibility-functions](automation/single-responsibility-functions.md)                  |
| `ADR-AUTO-CACHE`    | [caching](automation/caching.md)                                                                  |
| `ADR-AUTO-TRACKED`  | [tracked-files-from-the-index](automation/tracked-files-from-the-index.md)                        |
| `ADR-AUTO-DEFAULT`  | [sensible-defaults](automation/sensible-defaults.md)                                              |
| `ADR-AUTO-FAILFAST` | [fail-fast-with-asserts](automation/fail-fast-with-asserts.md)                                    |
| `ADR-AUTO-IDEM`     | [idempotent-state-functions](automation/idempotent-state-functions.md)                            |
| `ADR-AUTO-PKGMGR`   | [use-proper-package-managers](automation/use-proper-package-managers.md)                          |
| `ADR-AUTO-ENTERP`   | [effective-in-enterprises](automation/effective-in-enterprises.md)                                |
| `ADR-AUTO-DEPS`     | [controlling-systemwide-deps](automation/controlling-systemwide-deps.md)                          |
| `ADR-AUTO-REMOVE`   | [tool-removal-lifecycle](automation/tool-removal-lifecycle.md)                                    |
| `ADR-AUTO-DEPM`     | [controlling-module-dependencies](automation/controlling-module-dependencies.md)                  |
| `ADR-AUTO-ENVVAR`   | [environment-variables](automation/environment-variables.md)                                      |
| `ADR-AZ-SESSION`    | [az-session-verification](automation/az-session-verification.md)                                  |
| `ADR-AUTO-PATH`     | [path-representation](automation/path-representation.md)                                          |
| `ADR-REPO-PROTGLOB` | [protected-globs](automation/protected-globs.md)                                                  |
| `ADR-AUTO-GUIDS`    | [managed-guids](automation/managed-guids.md)                                                      |
| `ADR-AUTO-BUNDLE`   | [platform-bundle](automation/platform-bundle.md)                                                  |
| `ADR-AUTO-ASSETDEP` | [internal-asset-dependencies](automation/internal-asset-dependencies.md)                          |
| `ADR-AUTO-VENDOR`   | [vendor-toolset-dependencies](automation/powershell/vendor-toolset-dependencies.md)               |
| `ADR-AUTO-AZCLI`    | [prefer-az-cli](automation/powershell/prefer-az-cli.md)                                           |
| `ADR-AUTO-ONEFUNC`  | [one-function-per-file](automation/powershell/one-function-per-file.md)                           |
| `ADR-AUTO-PREPOST`  | [prepost-extension-modules](automation/powershell/prepost-extension-modules.md)                   |
| `ADR-AUTO-ERROR`    | [error-handling](automation/powershell/error-handling.md)                                         |
| `ADR-AUTO-NOSEMI`   | [avoid-using-semicolons](automation/powershell/avoid-using-semicolons.md)                         |
| `ADR-AUTO-CONSOLE`  | [console-output-matters](automation/powershell/console-output-matters.md)                         |
| `ADR-AUTO-ANNOUNCE` | [announce-state-changes](automation/powershell/announce-state-changes.md)                         |
| `ADR-AUTO-FOREACH`  | [prefer-foreach-over-foreach-object](automation/powershell/prefer-foreach-over-foreach-object.md) |
| `ADR-AUTO-VERBS`    | [respect-pwsh-verb-rules](automation/powershell/respect-pwsh-verb-rules.md)                       |
| `ADR-AUTO-SPELL`    | [spell-out-names](automation/powershell/spell-out-names.md)                                       |
| `ADR-AUTO-USEPS`    | [use-ps1-not-psm1](automation/powershell/use-ps1-not-psm1.md)                                     |
| `ADR-AUTO-AUTOVAR`  | [automatic-variable-pitfalls](automation/powershell/automatic-variable-pitfalls.md)               |
| `ADR-AUTO-PSFORMAT` | [powershell-formatting](automation/powershell/powershell-formatting.md)                           |
| `ADR-AUTO-PSENV`    | [environment-variable-mechanics](automation/powershell/environment-variable-mechanics.md)         |
| `ADR-AUTO-MODPATH`  | [module-path-hygiene](automation/powershell/module-path-hygiene.md)                               |
| `ADR-AUTO-PSPARAM`  | [parameter-design](automation/powershell/parameter-design.md)                                     |
| `ADR-AUTO-PSPWD`    | [working-directory-mechanics](automation/powershell/working-directory-mechanics.md)               |
| `ADR-AUTO-PSXPLAT`  | [cross-platform-powershell](automation/powershell/cross-platform-powershell.md)                   |
| `ADR-AUTO-MANIFEST` | [dynamic-module-manifests](automation/powershell/dynamic-module-manifests.md)                     |
| `ADR-AUTO-PSCACHE`  | [script-scope-caching](automation/powershell/script-scope-caching.md)                             |
| `ADR-AUTO-PESTER`   | [pester-testing](automation/powershell/pester-testing.md)                                         |
| `ADR-AUTO-DRYRUN`   | [prefer-dryrun-over-shouldprocess](automation/powershell/prefer-dryrun-over-shouldprocess.md)     |
| `ADR-AUTO-TYPES`    | [native-csharp-types](automation/BCL/native-csharp-types.md)                                      |
| `ADR-AUTO-GO`       | [test-artifacts](automation/go/test-artifacts.md)                                                 |

### configuration/

How a module's `configs/<name>.yml` files are read, validated, and addressed: one public reader, `Get-Config`, that discovers a config by
its global name, caches it per file, and validates it in its owning module's scope, plus `global.<config>.<key>` addresses that point into
committed config by reference. It gives every implementation domain its single way to read configuration.

**Role:** `implementation` — **depends on:** `research`, `principles`.

| Code                  | ADR                                                                 |
| --------------------- | ------------------------------------------------------------------- |
| `ADR-CONF-LOADING`    | [module-config-loading](configuration/module-config-loading.md)     |
| `ADR-CONF-ADDRESSING` | [config-value-addressing](configuration/config-value-addressing.md) |

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
(`network.yml`), and the deterministic resource-naming standard. It applies the principles and design domains to one vendor, enforced by the
`Catzc.Azure*` modules.

**Role:** `implementation` — **depends on:** `research`, `principles`, `design`, `automation`.

| Code              | ADR                                                     |
| ----------------- | ------------------------------------------------------- |
| `ADR-AZ-DATAMOD`  | [azure-data-model](azure/azure-data-model.md)           |
| `ADR-AZ-NETWORK`  | [azure-network-model](azure/azure-network-model.md)     |
| `ADR-AZ-NAMING`   | [azure-naming-standard](azure/azure-naming-standard.md) |
| `ADR-AZ-CUSTOMER` | [azure-customer-model](azure/azure-customer-model.md)   |

### repository/

How the repository tree is laid out, formatted, and generated: conventional folder names at every level, the single `out/` output directory,
one formatting standard for every file type, contracts at the repository boundary, in both directions, under `contracts/`, READMEs and root
configs generated from one source, fictional documentation examples, the separation of design, test, and live vocabulary, the controlled
vocabulary of defined terms, repo-wide variants, the sub-agent definitions and the rules behind each, and sibling repositories read for
ideas, never as a reference implementation.

**Role:** `implementation` — **depends on:** `research`, `principles`, `design`.

| Code                | ADR                                                                    |
| ------------------- | ---------------------------------------------------------------------- |
| `ADR-REPO-FOLDERS`  | [conventional-folders](repository/conventional-folders.md)             |
| `ADR-REPO-OUTDIR`   | [dedicated-output-directory](repository/dedicated-output-directory.md) |
| `ADR-REPO-FORMAT`   | [uniform-formatting](repository/uniform-formatting.md)                 |
| `ADR-REPO-CONTRACT` | [api-contracts](repository/api-contracts.md)                           |
| `ADR-REPO-README`   | [generated-readmes](repository/generated-readmes.md)                   |
| `ADR-REPO-ROOTCFG`  | [generated-root-configs](repository/generated-root-configs.md)         |
| `ADR-REPO-EXAMPLE`  | [documentation-examples](repository/documentation-examples.md)         |
| `ADR-REPO-VARIANT`  | [repo-variants](repository/repo-variants.md)                           |
| `ADR-REPO-LANG`     | [domain-language-separation](repository/domain-language-separation.md) |
| `ADR-REPO-VOCAB`    | [controlled-vocabulary](repository/controlled-vocabulary.md)           |
| `ADR-REPO-LINK`     | [markdown-links](repository/markdown-links.md)                         |
| `ADR-REPO-AGENTS`   | [agent-definitions](repository/agent-definitions.md)                   |
| `ADR-REPO-INSPIRE`  | [inspiration](repository/inspiration.md)                               |

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
  (`.editorconfig`, `PSScriptAnalyzerSettings.psd1`, `.markdownlint.yml`, `.gitattributes`, `automation/.scriptanalyzer/*.psm1`). Name the
  enforcing file as a pointer, but do not reproduce value tables, pasted `@{ }` rule blocks, or per-rule on/off lists — that duplication
  drifts. Naming a value in order to justify it (for example, "UTF-8, because a BOM breaks `git diff`") is fine; a bare value list with no
  rationale is not.

- **References point one way: code to ADR.** Code, function help, sample headers, and READMEs cite the relevant ADR; an ADR never links back
  to sample or example code, because that couples durable rationale to code churn. The "How this is enforced" sections that _name_ an
  enforcing function are the established exception.

- **Two kinds of link (ADR-REPO-LINK).** A markdown link, in a `.md` file, is relative to its own file
  (`[reduce-variability](../principles/reduce-variability.md)`). A code link, in a comment of any other file, is repository-rooted with the
  citation as its text (`[ADR-AZ-DATAMOD#2](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2)`); `Format-Links` writes it from the
  citation, and `Test-Links` checks both kinds.

- **Defined terms live in the glossary.** A defined term means what the one rule that bolds it says
  ([controlled-vocabulary](repository/controlled-vocabulary.md)); [glossary](glossary.md) lists every term with its defining rule, its
  contrasts, and the phrasings to avoid. It is generated from the modules' `configs/glossary.yml` sources — edit a source, never the page.

- **Link granularity is per-context.** Cite a specific rule anchor (`file.md#rule-<code><n>`, e.g.
  `azure-data-model.md#rule-adr-az-datamod2`) when the citing sentence, comment, or throw-message invokes one concrete rule. Link the ADR
  document when the context is general — an index list, a "see ADR X for the full rationale" pointer, or a citation that invokes the ADR's
  whole thesis. Over-narrowing a general pointer to one rule is worse than leaving it doc-level.

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
  capabilities that genuinely bear on an ADR's domain, never the whole catalogue.

- **The research ADRs carry their own `## Dora explains`.** Each `research/<slug>.md` is the record of one DORA capability, so it is the one
  place an ADR ends with a `## Dora explains` section: the capability's site category and Core Model position, the publications its evidence
  comes from, and its related capabilities, all as links into `docs/references/dora/`. `research/` therefore has no `dora-explains.md`.
