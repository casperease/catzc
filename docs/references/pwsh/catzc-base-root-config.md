# Catzc.Base.RootConfig

The managed root-config module. It owns the rule that an opted-in repository-root configuration file is **fully managed by the
source-of-truth automation** — materialised on every import from exactly one in-repo source of truth (see
[generated-root-configs](../../drs/repository/generated-root-configs.md)). Per entry, `committed` decides git membership — a
`committed: false` target is a gitignored derived artifact, a `committed: true` target stays tracked because it is needed before the
importer runs (`importer.ps1`). Every managed root file is a copy under the generated-file head, never a link to its template. Same
registry, same writer, same drift guarantee. What it deliberately does **not** own is the content itself — that lives in the authored
sources and generators its registry names; this module is only the pairing and the materialisation.

## Responsibilities

| Responsibility   | Area     | Name                                                                           |
| ---------------- | -------- | ------------------------------------------------------------------------------ |
| responsibility:1 | render   | [Managed-file materialisation](#responsibility1--managed-file-materialisation) |
| responsibility:2 | registry | [Root-config registry](#responsibility2--root-config-registry)                 |
| responsibility:3 | gates    | [Root-config quality gates](#responsibility3--root-config-quality-gates)       |

### responsibility:1 — Managed-file materialisation

Turning each opted-in registry entry into its root file. An entry obtains the content from its single source of truth — a `source` template
under the generated-file head that names it and carries the one warning, or a `generator` function's rendered output (dispatched by name, so
an unknown generator fails loudly) — and writes it through the shared `Write-FileIfChanged` primitive
([Catzc.Base.Files](catzc-base-files.md)): canonical output, EOL-insensitive compare, write only on a real change. That is idempotent, which
is what lets the importer materialise every managed root file on each load at no steady-state cost, and a target that is a link is stale
whatever its bytes, so it is deleted and written as a file of its own
([ADR-REPO-ROOTCFG-HEADEDCOPY](../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-headedcopy)).

A generator renders either one file or a set of them. A single-file generator returns the content of its entry's target; a multi-file
generator (the Go test workspace's `New-GoWorkspace`, [Catzc.Base.Languages](catzc-base-languages.md)) is handed the entry's target and
returns one `{ Target; Content }` record per file. Each record must match the target, and each is written on its own and reported in its own
result row under its own path, so a wildcard entry such as `go/tests/*/go.mod` materialises one file per Go test folder.

### responsibility:2 — Root-config registry

Which root file is managed, from what, and how it relates to git. The registry is `rootconfig.yml`: per entry a `target`, exactly one of
`source` or `generator`, the two booleans — `optIn` (is the file managed at all; **opt-out is the default**) and `committed` (gitignored
derived artifact vs tracked bootstrap file) — and an optional `carrier` that names where the head goes. A wildcard `target` names the set of
files a multi-file generator renders and is allowed only on a `generator` entry. It is validated when it loads so a malformed entry can
never produce a run. The registry is the single place the pairing is stated; the generator reads it through
[Catzc.Base.Config](catzc-base-config.md) and never hard-codes a path.

### responsibility:3 — Root-config quality gates

The quality gates ([ADR-AUTO-TEST-QUALITYGATE](../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the
materialised result. One checks that the registry, `.gitignore`, git's tracked set and the copies agree for every opted-in entry (each
`source` target is its template under the head, and no target is a link), a wildcard entry once per file its generator renders
([ADR-REPO-ROOTCFG-THREEWAYAGREEMENT](../../drs/repository/generated-root-configs.md)); the other checks the consumer contract of the root
`PSScriptAnalyzerSettings.psd1` — that a consumer opening the root path parses a non-empty settings hashtable under its head. Content drift
of a generated copy is [Catzc.Base.QualityGates](catzc-base-quality-gates.md)' `Test-GeneratedFiles`.

## What the module does

The module is small and single-purpose: it keeps every opted-in root config file in step with its one in-repo source of truth. It is the
root-file counterpart of [Catzc.Base.Docs](catzc-base-docs.md) — the same registry-plus-single-writer shape, applied to configuration
instead of prose — so each managed root file is one registry entry, never a bespoke builder.

Two design points carry the weight. First, **opt-out is the default**: a root file with no entry (or an entry with `optIn: false`) is simply
not touched, so takeover is always an explicit, reviewable registry change, and the rollout can proceed file by file. Second, **`committed`
is one boolean, not two systems**: `importer.ps1` cannot be a gitignored copy-in (it is the load entry point itself), but it is still fully
managed — its `generator` is `New-Importer` ([Catzc.Base.ModuleSystem](catzc-base-module-system.md)), and the same materialisation reports
it drift-free instead of silently rewriting a tracked file. The importer tail runs `Build-RootConfig` as a janitor on every load, so a clean
tree costs a few file reads and writes nothing. Because the janitor runs on every load, a bad root config breaks every session's next
import, not just the session that wrote it.

## Division

The module's public surface, sorted into the responsibilities above.

| Responsibility                                  | Function                    |
| ----------------------------------------------- | --------------------------- |
| responsibility:1 — Managed-file materialisation | `Build-RootConfig`          |
| responsibility:2 — Root-config registry         | `rootconfig.yml`            |
| responsibility:3 — Root-config quality gates    | `Test-RootConfigFiles`      |
|                                                 | `Test-RootAnalyzerSettings` |
