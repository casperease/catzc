# ADR index and rule-citation registry

Architecture Decision Records live under `docs/adr/`, grouped by area (`principles/`, `design/`, `automation/`, `pipelines/`, `azure/`,
`repository/`). **Read all ADRs at the start of every session** — they define the design principles this codebase must follow.

## Citing a rule

Every ADR carries a numbered rule registry as its first content section: `## Rules: <code>`, followed by `### Rule <code>:<n>` entries (each
a normative summary plus internal links to the prose that justifies it).

- Every `<code>` has the form `ADR-<NAME>` — a literal `ADR-` prefix plus 4–8 uppercase letters — so `ADR-` is the single searchable marker
  for a rule reference anywhere in the repository.
- **Cite a rule** as `<code>#<n>` — e.g. `ADR-ERROR#3`, `ADR-CACHE#9`, `ADR-NAMING#7`.
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

### design/

| Code       | ADR                                                                            |
| ---------- | ------------------------------------------------------------------------------ |
| `ADR-FLOW` | [ci-discipline-and-promotion-flow](design/ci-discipline-and-promotion-flow.md) |

### automation/

The cross-cutting platform and module-system rules live at the `automation/` root; language-specific rules live in the `powershell/` and
`BCL/` subfolders (`python/` and `go/` are reserved for future languages).

#### automation/ (cross-cutting)

| Code           | ADR                                                                              |
| -------------- | -------------------------------------------------------------------------------- |
| `ADR-VENDOR`   | [vendor-toolset-dependencies](automation/vendor-toolset-dependencies.md)         |
| `ADR-AZCLI`    | [prefer-az-cli](automation/prefer-az-cli.md)                                     |
| `ADR-UVPY`     | [uv-python-handler](automation/uv-python-handler.md)                             |
| `ADR-PRELOG`   | [log-before-invoke](automation/log-before-invoke.md)                             |
| `ADR-RETRY`    | [retry-as-last-resort](automation/retry-as-last-resort.md)                       |
| `ADR-EXTEND`   | [open-closed-architecture](automation/open-closed-architecture.md)               |
| `ADR-ONEFUNC`  | [one-function-per-file](automation/one-function-per-file.md)                     |
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
| `ADR-MODDEPS`  | [controlling-module-dependencies](automation/controlling-module-dependencies.md) |
| `ADR-PREPOST`  | [prepost-extension-modules](automation/prepost-extension-modules.md)             |
| `ADR-ENVVAR`   | [environment-variables](automation/environment-variables.md)                     |
| `ADR-AZSESS`   | [az-session-verification](automation/az-session-verification.md)                 |
| `ADR-PATH`     | [path-representation](automation/path-representation.md)                         |
| `ADR-CFGADDR`  | [config-value-addressing](automation/config-value-addressing.md)                 |
| `ADR-PROTGLOB` | [protected-globs](automation/protected-globs.md)                                 |

#### automation/powershell/

| Code           | ADR                                                                                               |
| -------------- | ------------------------------------------------------------------------------------------------- |
| `ADR-ERROR`    | [error-handling](automation/powershell/error-handling.md)                                         |
| `ADR-NOSEMI`   | [avoid-using-semicolons](automation/powershell/avoid-using-semicolons.md)                         |
| `ADR-CONSOLE`  | [console-output-matters](automation/powershell/console-output-matters.md)                         |
| `ADR-FOREACH`  | [prefer-foreach-over-foreach-object](automation/powershell/prefer-foreach-over-foreach-object.md) |
| `ADR-VERBS`    | [respect-pwsh-verb-rules](automation/powershell/respect-pwsh-verb-rules.md)                       |
| `ADR-SPELL`    | [spell-out-names](automation/powershell/spell-out-names.md)                                       |
| `ADR-USEPS`    | [use-ps1-not-psm1](automation/powershell/use-ps1-not-psm1.md)                                     |
| `ADR-AUTOVAR`  | [automatic-variable-pitfalls](automation/powershell/automatic-variable-pitfalls.md)               |
| `ADR-PSFORMAT` | [powershell-formatting](automation/powershell/powershell-formatting.md)                           |
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

### azure/

| Code           | ADR                                         |
| -------------- | ------------------------------------------- |
| `ADR-DATAMOD`  | [data-model](azure/data-model.md)           |
| `ADR-NETWORK`  | [network-model](azure/network-model.md)     |
| `ADR-NAMING`   | [naming-standard](azure/naming-standard.md) |
| `ADR-CUSTOMER` | [customer-model](azure/customer-model.md)   |

### repository/

| Code           | ADR                                                                    |
| -------------- | ---------------------------------------------------------------------- |
| `ADR-FOLDERS`  | [conventional-folders](repository/conventional-folders.md)             |
| `ADR-OUTDIR`   | [dedicated-output-directory](repository/dedicated-output-directory.md) |
| `ADR-FORMAT`   | [uniform-formatting](repository/uniform-formatting.md)                 |
| `ADR-CONTRACT` | [api-contracts](repository/api-contracts.md)                           |
| `ADR-README`   | [generated-readmes](repository/generated-readmes.md)                   |
| `ADR-EXAMPLE`  | [documentation-examples](repository/documentation-examples.md)         |
| `ADR-VARIANT`  | [repo-variants](repository/repo-variants.md)                           |

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

- **Link granularity is per-context.** Cite a specific rule anchor (`file.md#rule-<code><n>`, e.g. `data-model.md#rule-adr-datamod2`) when
  the citing sentence, comment, or throw-message invokes one concrete rule. Link the ADR document when the context is general — an index
  list, a "see ADR X for the full rationale" pointer, or a citation that invokes the ADR's whole thesis. Over-narrowing a general pointer to
  one rule is worse than leaving it doc-level.

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
