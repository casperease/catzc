# ADR index and rule-citation registry

Architecture Decision Records live under `docs/adr/`, grouped by area (`principles/`, `process/`, `design/`, `automation/`, `pipelines/`,
`azure/`, `repository/`, `research/`). **Read all ADRs at the start of every session** — they define the design principles this codebase
must follow.

## Citing a rule

Every ADR carries a numbered rule registry as its first content section: `## Rules: <code>`, followed by `### Rule <code>:<n>` entries (each
a normative summary plus internal links to the prose that justifies it).

- Every `<code>` has the form `ADR-<NAME>` — a literal `ADR-` prefix plus 4–8 uppercase letters — so `ADR-` is the single searchable marker
  for a rule reference anywhere in the repository.
- **Cite a rule** as `<code>#<n>` — e.g. `ADR-ERROR#3`, `ADR-CACHE#5`, `ADR-NAMING#7`.
- That resolves to the anchor `#rule-<code><n>` with the code lowercased and the `:` dropped — e.g.
  `automation/powershell/error-handling.md#rule-adr-error3` (so it is `rule-adr-error3`, not `rule-adr-error-3`).
- The `<code>` is unique per ADR; the table below is the authoritative code ↔ ADR mapping.

## Codes

### principles/

| Code          | ADR                                                    |
| ------------- | ------------------------------------------------------ |
| `ADR-ASCODE`  | [everything-as-code](principles/everything-as-code.md) |
| `ADR-LESSVAR` | [reduce-variability](principles/reduce-variability.md) |
| `ADR-NOWASTE` | [reduce-waste](principles/reduce-waste.md)             |
| `ADR-POKA`    | [poka-yoke](principles/poka-yoke.md)                   |
| `ADR-ONELIVE` | [one-living-version](principles/one-living-version.md) |

### process/

| Code           | ADR                                               |
| -------------- | ------------------------------------------------- |
| `ADR-AGILE`    | [agile](process/agile.md)                         |
| `ADR-AGILEV`   | [agile-values](process/agile-values.md)           |
| `ADR-AGILEP`   | [agile-principles](process/agile-principles.md)   |
| `ADR-PTERMS`   | [process-terms](process/process-terms.md)         |
| `ADR-LEAN`     | [lean](process/lean.md)                           |
| `ADR-HOLDLINE` | [holding-the-line](process/holding-the-line.md)   |
| `ADR-BUILTIN`  | [build-quality-in](process/build-quality-in.md)   |
| `ADR-OBSERVE`  | [observe-work](process/observe-work.md)           |
| `ADR-PULL`     | [pull-work](process/pull-work.md)                 |
| `ADR-QUEUE`    | [queues-cost-money](process/queues-cost-money.md) |
| `ADR-ADAPT`    | [inspect-and-adapt](process/inspect-and-adapt.md) |

### design/

| Code           | ADR                                                                            |
| -------------- | ------------------------------------------------------------------------------ |
| `ADR-FLOW`     | [ci-discipline-and-promotion-flow](design/ci-discipline-and-promotion-flow.md) |
| `ADR-TRACK`    | [tracks](design/tracks.md)                                                     |
| `ADR-THINPLAT` | [thin-platforms](design/thin-platforms.md)                                     |
| `ADR-SELFSERV` | [self-service](design/self-service.md)                                         |
| `ADR-VISUAL`   | [visual-design](design/visual-design.md)                                       |
| `ADR-LIFE`     | [commit-lifecycle](design/commit-lifecycle.md)                                 |
| `ADR-REMOTE`   | [server-remote-integration](design/server-remote-integration.md)               |

### automation/

The cross-cutting platform and module-system rules live at the `automation/` root; language-specific rules live in the `powershell/` and
`BCL/` subfolders (`python/` and `go/` are reserved for future languages).

#### automation/ (cross-cutting)

| Code           | ADR                                                                              |
| -------------- | -------------------------------------------------------------------------------- |
| `ADR-PARITY`   | [devbox-pipeline-parity](automation/devbox-pipeline-parity.md)                   |
| `ADR-UVPY`     | [uv-python-handler](automation/uv-python-handler.md)                             |
| `ADR-PRELOG`   | [log-before-invoke](automation/log-before-invoke.md)                             |
| `ADR-RETRY`    | [retry-as-last-resort](automation/retry-as-last-resort.md)                       |
| `ADR-EXTEND`   | [open-closed-architecture](automation/open-closed-architecture.md)               |
| `ADR-ZERO`     | [zero-ceremony-poka-yoke](automation/zero-ceremony-poka-yoke.md)                 |
| `ADR-NOPWD`    | [never-depend-on-pwd](automation/never-depend-on-pwd.md)                         |
| `ADR-NONEST`   | [avoid-deep-nesting](automation/avoid-deep-nesting.md)                           |
| `ADR-TEST`     | [test-automation](automation/test-automation.md)                                 |
| `ADR-XPLAT`    | [cross-platform](automation/cross-platform.md)                                   |
| `ADR-ONEJOB`   | [single-responsibility-functions](automation/single-responsibility-functions.md) |
| `ADR-CACHE`    | [caching](automation/caching.md)                                                 |
| `ADR-MODCFG`   | [module-config-loading](automation/module-config-loading.md)                     |
| `ADR-DEFAULT`  | [sensible-defaults](automation/sensible-defaults.md)                             |
| `ADR-FAILFAST` | [fail-fast-with-asserts](automation/fail-fast-with-asserts.md)                   |
| `ADR-IDEM`     | [idempotent-state-functions](automation/idempotent-state-functions.md)           |
| `ADR-PKGMGR`   | [use-proper-package-managers](automation/use-proper-package-managers.md)         |
| `ADR-ENTERP`   | [effective-in-enterprises](automation/effective-in-enterprises.md)               |
| `ADR-SYSDEPS`  | [controlling-systemwide-deps](automation/controlling-systemwide-deps.md)         |
| `ADR-REMOVE`   | [tool-removal-lifecycle](automation/tool-removal-lifecycle.md)                   |
| `ADR-MODDEPS`  | [controlling-module-dependencies](automation/controlling-module-dependencies.md) |
| `ADR-ENVVAR`   | [environment-variables](automation/environment-variables.md)                     |
| `ADR-AZSESS`   | [az-session-verification](automation/az-session-verification.md)                 |
| `ADR-PATH`     | [path-representation](automation/path-representation.md)                         |
| `ADR-CFGADDR`  | [config-value-addressing](automation/config-value-addressing.md)                 |
| `ADR-PROTGLOB` | [protected-globs](automation/protected-globs.md)                                 |
| `ADR-GUIDS`    | [managed-guids](automation/managed-guids.md)                                     |
| `ADR-BUNDLE`   | [platform-bundle](automation/platform-bundle.md)                                 |

#### automation/powershell/

| Code           | ADR                                                                                               |
| -------------- | ------------------------------------------------------------------------------------------------- |
| `ADR-VENDOR`   | [vendor-toolset-dependencies](automation/powershell/vendor-toolset-dependencies.md)               |
| `ADR-AZCLI`    | [prefer-az-cli](automation/powershell/prefer-az-cli.md)                                           |
| `ADR-ONEFUNC`  | [one-function-per-file](automation/powershell/one-function-per-file.md)                           |
| `ADR-PREPOST`  | [prepost-extension-modules](automation/powershell/prepost-extension-modules.md)                   |
| `ADR-ERROR`    | [error-handling](automation/powershell/error-handling.md)                                         |
| `ADR-NOSEMI`   | [avoid-using-semicolons](automation/powershell/avoid-using-semicolons.md)                         |
| `ADR-CONSOLE`  | [console-output-matters](automation/powershell/console-output-matters.md)                         |
| `ADR-FOREACH`  | [prefer-foreach-over-foreach-object](automation/powershell/prefer-foreach-over-foreach-object.md) |
| `ADR-VERBS`    | [respect-pwsh-verb-rules](automation/powershell/respect-pwsh-verb-rules.md)                       |
| `ADR-SPELL`    | [spell-out-names](automation/powershell/spell-out-names.md)                                       |
| `ADR-USEPS`    | [use-ps1-not-psm1](automation/powershell/use-ps1-not-psm1.md)                                     |
| `ADR-AUTOVAR`  | [automatic-variable-pitfalls](automation/powershell/automatic-variable-pitfalls.md)               |
| `ADR-PSFORMAT` | [powershell-formatting](automation/powershell/powershell-formatting.md)                           |
| `ADR-PSENV`    | [environment-variable-mechanics](automation/powershell/environment-variable-mechanics.md)         |
| `ADR-MODPATH`  | [module-path-hygiene](automation/powershell/module-path-hygiene.md)                               |
| `ADR-PSPARAM`  | [parameter-design](automation/powershell/parameter-design.md)                                     |
| `ADR-PSPWD`    | [working-directory-mechanics](automation/powershell/working-directory-mechanics.md)               |
| `ADR-PSXPLAT`  | [cross-platform-powershell](automation/powershell/cross-platform-powershell.md)                   |
| `ADR-MANIFEST` | [dynamic-module-manifests](automation/powershell/dynamic-module-manifests.md)                     |
| `ADR-PSCACHE`  | [script-scope-caching](automation/powershell/script-scope-caching.md)                             |
| `ADR-PESTER`   | [pester-testing](automation/powershell/pester-testing.md)                                         |
| `ADR-DRYRUN`   | [prefer-dryrun-over-shouldprocess](automation/powershell/prefer-dryrun-over-shouldprocess.md)     |

#### automation/BCL/

| Code        | ADR                                                          |
| ----------- | ------------------------------------------------------------ |
| `ADR-TYPES` | [native-csharp-types](automation/BCL/native-csharp-types.md) |

### pipelines/

| Code           | ADR                                                                         |
| -------------- | --------------------------------------------------------------------------- |
| `ADR-RUNNER`   | [pipeline-runner-pattern](pipelines/pipeline-runner-pattern.md)             |
| `ADR-PIPEDET`  | [pipeline-detection](pipelines/pipeline-detection.md)                       |
| `ADR-PIPETYPE` | [pipeline-types](pipelines/pipeline-types.md)                               |
| `ADR-AUTH`     | [dual-authentication](pipelines/dual-authentication.md)                     |
| `ADR-PIPEVAR`  | [pipeline-variables](pipelines/pipeline-variables.md)                       |
| `ADR-PIPENAME` | [pipeline-naming-and-placement](pipelines/pipeline-naming-and-placement.md) |
| `ADR-TEMPLATE` | [custom-template-discipline](pipelines/custom-template-discipline.md)       |
| `ADR-GLOBS`    | [durable-sha-globs](pipelines/durable-sha-globs.md)                         |
| `ADR-RELEASE`  | [github-release](pipelines/github-release.md)                               |

### azure/

| Code           | ADR                                                     |
| -------------- | ------------------------------------------------------- |
| `ADR-DATAMOD`  | [azure-data-model](azure/azure-data-model.md)           |
| `ADR-NETWORK`  | [azure-network-model](azure/azure-network-model.md)     |
| `ADR-NAMING`   | [azure-naming-standard](azure/azure-naming-standard.md) |
| `ADR-CUSTOMER` | [azure-customer-model](azure/azure-customer-model.md)   |

### repository/

| Code           | ADR                                                                    |
| -------------- | ---------------------------------------------------------------------- |
| `ADR-FOLDERS`  | [conventional-folders](repository/conventional-folders.md)             |
| `ADR-OUTDIR`   | [dedicated-output-directory](repository/dedicated-output-directory.md) |
| `ADR-FORMAT`   | [uniform-formatting](repository/uniform-formatting.md)                 |
| `ADR-CONTRACT` | [api-contracts](repository/api-contracts.md)                           |
| `ADR-README`   | [generated-readmes](repository/generated-readmes.md)                   |
| `ADR-ROOTCFG`  | [generated-root-configs](repository/generated-root-configs.md)         |
| `ADR-EXAMPLE`  | [documentation-examples](repository/documentation-examples.md)         |
| `ADR-VARIANT`  | [repo-variants](repository/repo-variants.md)                           |
| `ADR-LANG`     | [domain-language-separation](repository/domain-language-separation.md) |

### research/

DORA capability summaries — one ADR per capability in the [DORA Core Model](research/index.md), grouped as the DORA catalog groups them.
These articles summarize external research; the repository's own decisions live in the areas above.

#### research/ — AI-focused

| Code          | ADR                                                                              |
| ------------- | -------------------------------------------------------------------------------- |
| `ADR-DORAAID` | [ai-accessible-internal-data](research/ai-accessible-internal-data.md)           |
| `ADR-DORAAIS` | [clear-and-communicated-ai-stance](research/clear-and-communicated-ai-stance.md) |
| `ADR-DORAHDE` | [healthy-data-ecosystems](research/healthy-data-ecosystems.md)                   |
| `ADR-DORAPE`  | [platform-engineering](research/platform-engineering.md)                         |
| `ADR-DORAUCF` | [user-centric-focus](research/user-centric-focus.md)                             |
| `ADR-DORAVC`  | [version-control](research/version-control.md)                                   |
| `ADR-DORASB`  | [working-in-small-batches](research/working-in-small-batches.md)                 |

#### research/ — technical

| Code          | ADR                                                                      |
| ------------- | ------------------------------------------------------------------------ |
| `ADR-DORACM`  | [code-maintainability](research/code-maintainability.md)                 |
| `ADR-DORACD`  | [continuous-delivery](research/continuous-delivery.md)                   |
| `ADR-DORACI`  | [continuous-integration](research/continuous-integration.md)             |
| `ADR-DORADCM` | [database-change-management](research/database-change-management.md)     |
| `ADR-DORADA`  | [deployment-automation](research/deployment-automation.md)               |
| `ADR-DORADQ`  | [documentation-quality](research/documentation-quality.md)               |
| `ADR-DORAFI`  | [flexible-infrastructure](research/flexible-infrastructure.md)           |
| `ADR-DORALCT` | [loosely-coupled-teams](research/loosely-coupled-teams.md)               |
| `ADR-DORAMO`  | [monitoring-and-observability](research/monitoring-and-observability.md) |
| `ADR-DORAPS`  | [pervasive-security](research/pervasive-security.md)                     |
| `ADR-DORASCA` | [streamlining-change-approval](research/streamlining-change-approval.md) |
| `ADR-DORATA`  | [test-automation](research/test-automation.md)                           |
| `ADR-DORATDM` | [test-data-management](research/test-data-management.md)                 |
| `ADR-DORATBD` | [trunk-based-development](research/trunk-based-development.md)           |

#### research/ — process and measurement

| Code          | ADR                                                                            |
| ------------- | ------------------------------------------------------------------------------ |
| `ADR-DORACF`  | [customer-feedback](research/customer-feedback.md)                             |
| `ADR-DORAMS`  | [monitoring-systems](research/monitoring-systems.md)                           |
| `ADR-DORAPFN` | [proactive-failure-notification](research/proactive-failure-notification.md)   |
| `ADR-DORAWV`  | [work-visibility-in-value-stream](research/work-visibility-in-value-stream.md) |
| `ADR-DORAVM`  | [visual-management](research/visual-management.md)                             |
| `ADR-DORAWIP` | [wip-limits](research/wip-limits.md)                                           |

#### research/ — organizational and cultural

| Code          | ADR                                                                                |
| ------------- | ---------------------------------------------------------------------------------- |
| `ADR-DORAECT` | [teams-empowered-to-choose-tools](research/teams-empowered-to-choose-tools.md)     |
| `ADR-DORAGOC` | [generative-organizational-culture](research/generative-organizational-culture.md) |
| `ADR-DORAJS`  | [job-satisfaction](research/job-satisfaction.md)                                   |
| `ADR-DORALC`  | [learning-culture](research/learning-culture.md)                                   |
| `ADR-DORATE`  | [team-experimentation](research/team-experimentation.md)                           |
| `ADR-DORATL`  | [transformational-leadership](research/transformational-leadership.md)             |
| `ADR-DORAWB`  | [well-being](research/well-being.md)                                               |

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

- **Link granularity is per-context.** Cite a specific rule anchor (`file.md#rule-<code><n>`, e.g. `azure-data-model.md#rule-adr-datamod2`)
  when the citing sentence, comment, or throw-message invokes one concrete rule. Link the ADR document when the context is general — an
  index list, a "see ADR X for the full rationale" pointer, or a citation that invokes the ADR's whole thesis. Over-narrowing a general
  pointer to one rule is worse than leaving it doc-level.

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

- **`## Dora explains` closes every ADR.** The final section of each ADR is `## Dora explains` — a short, present-tense paragraph tying the
  ADR's topic to [DORA](https://dora.dev/research/) research, followed by a bullet list of the domain-relevant DORA capability links (2–4
  capabilities, each as `[Capability](https://dora.dev/capabilities/<slug>/) — why it is relevant`, plus the research-overview link). DORA
  is the repository's cross-cutting authoritative source on delivery performance; link only the capabilities that genuinely bear on the
  ADR's domain, never the whole catalog.
