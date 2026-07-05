# Catzc.Base.RootConfig

The managed root-config module. It owns the rule that an opted-in repository-root configuration file is **fully managed by the
source-of-truth automation** — reproduced on every import from exactly one in-repo source of truth, never hand-edited (see
[generated-root-configs](../../adr/repository/generated-root-configs.md)). Per entry, one boolean decides git membership: a
`committed: false` target is a gitignored derived copy (the root `PSScriptAnalyzerSettings.psd1`), a `committed: true` target stays tracked
because it is needed before the importer runs (`importer.ps1`) — same registry, same writer, same drift guarantee. What it deliberately does
**not** own is the content itself — that lives in the authored sources and generators its registry names; this module is only the pairing
and the materialisation.

## Domains

| Domain   | Area     | Name                                                             |
| -------- | -------- | ---------------------------------------------------------------- |
| domain:1 | render   | [Managed-file materialisation](#domain1--managed-file-materialisation) |
| domain:2 | registry | [Root-config registry](#domain2--root-config-registry)           |

### domain:1 — Managed-file materialisation

Turning each opted-in registry entry into its root file. This domain obtains the content from the entry's single source of truth — a
`source` file read and prefixed with the `comment`-style generated-file header, or a `generator` function's rendered output (dispatched by
name, so an unknown generator fails loudly) — and writes it through the shared `Write-FileIfChanged` primitive
([Catzc.Base.Files](catzc-base-files.md)): canonical output, EOL-insensitive compare, write only on a real change. That idempotence is what
lets the importer materialise every managed root file on each load at no steady-state cost.

### domain:2 — Root-config registry

Which root file is managed, from what, and how it relates to git. The registry is `rootconfig.yml`: per entry a `target`, exactly one of
`source` or `generator`, and the two booleans — `optIn` (is the file managed at all; **opt-out is the default**) and `committed` (gitignored
derived copy vs tracked bootstrap file). It is validated when it loads so a malformed entry can never produce a run, and the integrity test
asserts the registry, `.gitignore`, and git's tracked set agree ([ADR-ROOTCFG:6](../../adr/repository/generated-root-configs.md)). The
registry is the single place the pairing is stated; the generator reads it through [Catzc.Base.Config](catzc-base-config.md) and never
hard-codes a path.

## What the module does

The module is small and single-purpose: it keeps every opted-in root config file in step with its one in-repo source of truth. It is the
root-file counterpart of [Catzc.Base.Docs](catzc-base-docs.md) — the same registry-plus-single-writer shape, applied to configuration
instead of prose — and it replaced the bespoke per-file builders (the old root-analyzer-settings writer is deleted; its behaviour is now one
`source` entry).

Two design points carry the weight. First, **opt-out is the default**: a root file with no entry (or an entry with `optIn: false`) is simply
not touched, so takeover is always an explicit, reviewable registry change, and the rollout can proceed file by file. Second, **`committed`
is one boolean, not two systems**: `importer.ps1` cannot be a gitignored copy-in (it is the load entry point itself), but it is still fully
managed — its `generator` is `New-Importer` ([Catzc.Base.ModuleSystem](catzc-base-modulesystem.md)), and the same materialisation reports it
drift-free instead of silently rewriting a tracked file. The importer tail runs `Build-RootConfig` as a janitor on every load, so a clean
tree costs a few file reads and writes nothing.

## Division

The module's public surface, sorted into the domains above.

| Domain                                  | Function           |
| --------------------------------------- | ------------------ |
| domain:1 — Managed-file materialisation | `Build-RootConfig` |
| domain:2 — Root-config registry         | `rootconfig.yml`   |
